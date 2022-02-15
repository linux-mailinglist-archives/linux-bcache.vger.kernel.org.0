Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C2F4B6613
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Feb 2022 09:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbiBOIaU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 15 Feb 2022 03:30:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbiBOIaS (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 15 Feb 2022 03:30:18 -0500
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Feb 2022 00:30:08 PST
Received: from qq.com (smtpbg456.qq.com [59.36.132.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFE3DAAF9
        for <linux-bcache@vger.kernel.org>; Tue, 15 Feb 2022 00:30:08 -0800 (PST)
X-QQ-mid: bizesmtp53t1644913682t9bgqp25
Received: from localhost.localdomain (unknown [116.24.152.144])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 15 Feb 2022 16:28:01 +0800 (CST)
X-QQ-SSF: 01400000002000B0E000B00A0000000
X-QQ-FEAT: XcJ1Se6Wjem+e6IqeEI5ANR6k6m87OsB4wTZZnCvhTr2roSFDrxbcy1jUjRRU
        MT3mYYhem+rj86pY0ft5TWiTZH2VkUuZcjIQkH2r/XjSw8k7ZoHMpDVteIFPVnLmJfx9TzY
        zNrvtCcVm9o+mNiFIwI1Xbw5xflDTxbHkcy3XANupWil2jC058bihhIIF7hK4egI8LDG7ca
        Nmvgx3Jiy2FoD9mdbzegnZhlGV+fBuKu+Ylo20gDdId+Xt4kf4+l7xYhv7n3+lZmL363IZU
        lcOcviBqOWcX8HGUf8Vw7sofeGSeeS5eH+NyN2NYVM3m8CWKyjJD+/ox8mryhtU0meru9Yf
        THTIDaYKClSRVaUl/yQNxXBjQcafg==
X-QQ-GoodBg: 2
From:   Minlan Wang <wangminlan@szsandstone.com>
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     wangminlan@szsandstone.com
Subject: [PATCH] bcache: fix insane -ESRCH error in bch_journal_replay
Date:   Tue, 15 Feb 2022 03:28:01 -0500
Message-Id: <20220215082801.266620-1-wangminlan@szsandstone.com>
X-Mailer: git-send-email 2.18.4
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:szsandstone.com:qybgforeign:qybgforeign7
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

bch_keylist_empty is checked to make sure key insert is successful

Signed-off-by: Minlan Wang <wangminlan@szsandstone.com>
---
We've been using a pretty old version of bcache (from
linux-4.18-rc8) and experiencing occasional data corruption
after a new register session of bcache.  It turns out the
data corruption is caused by this code in our old version of
bcache:

in bch_journal_replay:
		 ...
                 for (k = i->j.start;
                      k < bset_bkey_last(&i->j);
                      k = bkey_next(k)) {
                         trace_bcache_journal_replay_key(k);

                         bch_keylist_init_single(&keylist, k);

                         ret = bch_btree_insert(s, &keylist, i->pin, NULL);
                         if (ret)
                                 goto err;
		 ...
bch_journal_replay returns -ESRCH, then in run_cache_set:
		 ...
                 if (j->version < BCACHE_JSET_VERSION_UUID)
                         __uuid_write(c);

                 bch_journal_replay(c, &journal);
		 ...
There's no message warning about this key insert error in
journal replay, nor does run_cache_set check for return
value of bch_journal_replay either, so later keys in jset
got lost silently and cause data corruption.

We checked the key which caused this failure in
bch_journal_replay, it is a key mapped to 2 btree node, and
the first btree node is full.
The code path causing this problem is:
1. k1 mapped to btree node n1, n2
2. When mapping into n1, bch_btree_insert_node goes into
   split case, top half of k1, say k1.1, is inserted into
   splitted n1: say n1.1, n1.2. Since the bottom half of k1,
   say k1.2, is left in insert_keys, so bch_btree_insert_node
   returns -EINTR.
   This happens in this code:
   in bch_btree_insert_node:
        ...
        } else {
                /* Invalidated all iterators */
                int ret = btree_split(b, op, insert_keys, replace_key);

                if (bch_keylist_empty(insert_keys))
                        return 0;
                else if (!ret)
                        return -EINTR;
                return ret;
        }
        ...
3. For return value -EINTR, another
   bch_btree_map_nodes_recurse in bcache_btree_root is
   triggered, with the wrong "from" key: which is
   START_KEY(&k1), instead of START_KEY(&k1.2)
4. n1.2 is revisted, since it has no overlapping range for
   k1.2, bch_btree_insert_keys sets
   op->insert_collision = true
   in the following code path:
   btree_insert_fn
   --> bch_btree_insert_node
     --> bch_btree_insert_keys
5. n2 is visisted and k1.2 is inserted here
6. bch_btree_insert detects op.op.insert_collision, and
   returns -ESRCH

In this case, the key is successfully inserted, though
bch_btree_insert returns -ESRCH.

We tried the latest version of bcache in linux mainline,
which has commit ce3e4cfb59cb (bcache: add failure check to
run_cache_set() for journal replay), the cache disk register
failed with this message:
bcache: replay journal failed, disabling caching

This is not what is expected, since the data in disk in
intact, journal replay should success.
I'm wondering if the checking of bch_btree_insert's return
value is really neccessary in bch_journal_replay, could we
just check bch_keylist_empty(&keylist) and make the replay
continue if that is empty?

We are using this patch for a work around for this issue now.

 drivers/md/bcache/journal.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 61bd79babf7a..35b8cbcd73c5 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -380,6 +380,8 @@ int bch_journal_replay(struct cache_set *s, struct list_head *list)
 			bch_keylist_init_single(&keylist, k);
 
 			ret = bch_btree_insert(s, &keylist, i->pin, NULL);
+			if ((ret == -ESRCH) && (bch_keylist_empty(&keylist)))
+				ret = 0;
 			if (ret)
 				goto err;
 
-- 
2.18.4



