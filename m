Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C8F5265F3
	for <lists+linux-bcache@lfdr.de>; Fri, 13 May 2022 17:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381920AbiEMPWl (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 13 May 2022 11:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381916AbiEMPWl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 May 2022 11:22:41 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A2866F86
        for <linux-bcache@vger.kernel.org>; Fri, 13 May 2022 08:22:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 50F481F900;
        Fri, 13 May 2022 15:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652455359; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VF+9uw+D5l6+CxECKGhEn3C+FM5oIFWP02N4oDUuksY=;
        b=Hsb1uK85mWHakULXoHVT6H8KWxgDhfO2jXPV1/3YhiZc3lx56SeUmaRZ/2BHfpvQb7ronV
        Iqx0Y3KkI8DcvN8vawaxbdPXebwAd5MDoIlSDIPKmpyo2jXXF7ymN+YX8U4xO5v1CvwEyz
        u6EBbHjBUnGMHwEQVDow5BthgL1Yuv0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652455359;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VF+9uw+D5l6+CxECKGhEn3C+FM5oIFWP02N4oDUuksY=;
        b=UODy5o5J230vpiZ6ytxKYm+Q4GeFw3u19u9MBpqjpZMUsZqcmO5OW5RDtDgYqBB4UNou2h
        qODs3k+PmPkRgxCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B9E7D13446;
        Fri, 13 May 2022 15:22:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VcvgHLx3fmKAIwAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 13 May 2022 15:22:36 +0000
Message-ID: <e1e3b849-2eec-3bf3-5d05-740a9813e1f1@suse.de>
Date:   Fri, 13 May 2022 23:22:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH] bcache: fix insane -ESRCH error in bch_journal_replay
Content-Language: en-US
To:     Minlan Wang <wangminlan@szsandstone.com>
References: <20220215082801.266620-1-wangminlan@szsandstone.com>
Cc:     linux-bcache@vger.kernel.org
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220215082801.266620-1-wangminlan@szsandstone.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/15/22 4:28 PM, Minlan Wang wrote:
> bch_keylist_empty is checked to make sure key insert is successful
>
> Signed-off-by: Minlan Wang <wangminlan@szsandstone.com>
> ---
> We've been using a pretty old version of bcache (from
> linux-4.18-rc8) and experiencing occasional data corruption
> after a new register session of bcache.  It turns out the
> data corruption is caused by this code in our old version of
> bcache:
>
> in bch_journal_replay:
> 		 ...
>                   for (k = i->j.start;
>                        k < bset_bkey_last(&i->j);
>                        k = bkey_next(k)) {
>                           trace_bcache_journal_replay_key(k);
>
>                           bch_keylist_init_single(&keylist, k);
>
>                           ret = bch_btree_insert(s, &keylist, i->pin, NULL);
>                           if (ret)
>                                   goto err;
> 		 ...
> bch_journal_replay returns -ESRCH, then in run_cache_set:
> 		 ...
>                   if (j->version < BCACHE_JSET_VERSION_UUID)
>                           __uuid_write(c);
>
>                   bch_journal_replay(c, &journal);
> 		 ...
> There's no message warning about this key insert error in
> journal replay, nor does run_cache_set check for return
> value of bch_journal_replay either, so later keys in jset
> got lost silently and cause data corruption.
>
> We checked the key which caused this failure in
> bch_journal_replay, it is a key mapped to 2 btree node, and
> the first btree node is full.
> The code path causing this problem is:
> 1. k1 mapped to btree node n1, n2


Hi Minlan,


Could you please provide more details about how the key 'k1' mapped to 
btree node n1 and n2 both?

Thanks.


Coly Li



> 2. When mapping into n1, bch_btree_insert_node goes into
>     split case, top half of k1, say k1.1, is inserted into
>     splitted n1: say n1.1, n1.2. Since the bottom half of k1,
>     say k1.2, is left in insert_keys, so bch_btree_insert_node
>     returns -EINTR.
>     This happens in this code:
>     in bch_btree_insert_node:
>          ...
>          } else {
>                  /* Invalidated all iterators */
>                  int ret = btree_split(b, op, insert_keys, replace_key);
>
>                  if (bch_keylist_empty(insert_keys))
>                          return 0;
>                  else if (!ret)
>                          return -EINTR;
>                  return ret;
>          }
>          ...
> 3. For return value -EINTR, another
>     bch_btree_map_nodes_recurse in bcache_btree_root is
>     triggered, with the wrong "from" key: which is
>     START_KEY(&k1), instead of START_KEY(&k1.2)
> 4. n1.2 is revisted, since it has no overlapping range for
>     k1.2, bch_btree_insert_keys sets
>     op->insert_collision = true
>     in the following code path:
>     btree_insert_fn
>     --> bch_btree_insert_node
>       --> bch_btree_insert_keys
> 5. n2 is visisted and k1.2 is inserted here
> 6. bch_btree_insert detects op.op.insert_collision, and
>     returns -ESRCH
>
> In this case, the key is successfully inserted, though
> bch_btree_insert returns -ESRCH.
>
> We tried the latest version of bcache in linux mainline,
> which has commit ce3e4cfb59cb (bcache: add failure check to
> run_cache_set() for journal replay), the cache disk register
> failed with this message:
> bcache: replay journal failed, disabling caching
>
> This is not what is expected, since the data in disk in
> intact, journal replay should success.
> I'm wondering if the checking of bch_btree_insert's return
> value is really neccessary in bch_journal_replay, could we
> just check bch_keylist_empty(&keylist) and make the replay
> continue if that is empty?
>
> We are using this patch for a work around for this issue now.
>
>   drivers/md/bcache/journal.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
> index 61bd79babf7a..35b8cbcd73c5 100644
> --- a/drivers/md/bcache/journal.c
> +++ b/drivers/md/bcache/journal.c
> @@ -380,6 +380,8 @@ int bch_journal_replay(struct cache_set *s, struct list_head *list)
>   			bch_keylist_init_single(&keylist, k);
>   
>   			ret = bch_btree_insert(s, &keylist, i->pin, NULL);
> +			if ((ret == -ESRCH) && (bch_keylist_empty(&keylist)))
> +				ret = 0;
>   			if (ret)
>   				goto err;
>   


