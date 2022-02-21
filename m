Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6664BE45A
	for <lists+linux-bcache@lfdr.de>; Mon, 21 Feb 2022 18:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352841AbiBUKK1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 21 Feb 2022 05:10:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353270AbiBUKJ7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 21 Feb 2022 05:09:59 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BCB56C0A
        for <linux-bcache@vger.kernel.org>; Mon, 21 Feb 2022 01:33:37 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id q1so3859421plx.4
        for <linux-bcache@vger.kernel.org>; Mon, 21 Feb 2022 01:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:to:cc:from:subject
         :content-transfer-encoding;
        bh=Wby8Xqh+ppDkwGCT7VOiHRwHGKjoLi+CFgoxH0aK3jw=;
        b=DPQhi+6bggdj55eOuz+Byk4te5HZsS1Lu/KkmjbkeUsZlDyk2K+rSede61ECWgVkji
         F098YIOZa87IyXFXxBjuelxYlLlifE6CpoLbiFeyxRgoc7aXsBiDEoP66+M80F4tsglT
         5pLQ1dQ86htcLBAEDtfr2LiIpZBIgunQ613qTrRuDOzFTLqDuzgK/IO+vycPdecHX6aE
         wQgPc80AflnyZ1J+CfWnF+agjbvInJXEGgpK3MTaZ3ccSzGEp+3rdZdsXCteYHNLTqw5
         AqZgDtyyXCzmdxtMmKTMpwjwmXkHPY0NayYGqXsx8Cu2eHUcclQk6xUAh9Rw3fZ5CVlk
         eMPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:to:cc
         :from:subject:content-transfer-encoding;
        bh=Wby8Xqh+ppDkwGCT7VOiHRwHGKjoLi+CFgoxH0aK3jw=;
        b=u9Ij3w8HBImMYTWtX3p21+Cu76z8hV9F6uM4MF2d5q33ZE2TFS6mLI5iadNF3khsJP
         Jrhey6dQFwb2WqRy0sUb/mnx4Ib7uTLViT1U2lXNth9OcIbQZ8xmrk8dHNV2QtCuLtbi
         Qd8AgSnu0PD4b8PiCCw8rLGGI7ycxpNtFeAMJzVB9XdHyj6ahDFZPqSL8cAl5aEth0r2
         9nEd6hdlnMforS6WLGJh9k8KgEJ6Quc7Qt70TV1+DHFkvecO6g/D7mwx5BqW/RE+ppwq
         TdbFLo98ZKGrMFW4stSbqNH1nCR4bKaPVa6v1FSkE7f3QNB6q0AUHlcaQsWNet6O8+/y
         rMZQ==
X-Gm-Message-State: AOAM531Xvf8HgsNBhVr7oQgpjU5L9AuJW6VQdPhHFWfrv8CeRcHxre8s
        1MfQkqs7JJSgTKMQZT0Hq76Ax6waOABt+sPmGTE=
X-Google-Smtp-Source: ABdhPJwd7ZtWLjiIEiaIcZsowfcKodkeESgwabS5o70bETZ+6Hn4dboXF9R1sJBN7SKVdXOwP5Wixw==
X-Received: by 2002:a17:902:d4cf:b0:14d:70a9:6a2f with SMTP id o15-20020a170902d4cf00b0014d70a96a2fmr18370937plg.19.1645436016642;
        Mon, 21 Feb 2022 01:33:36 -0800 (PST)
Received: from [172.20.104.20] ([61.16.102.70])
        by smtp.gmail.com with ESMTPSA id b8sm12432489pfv.74.2022.02.21.01.33.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 01:33:36 -0800 (PST)
Message-ID: <e6c45b07-769c-575b-0d9c-929aba6ab21a@gmail.com>
Date:   Mon, 21 Feb 2022 17:33:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
To:     colyli@suse.de
Cc:     linux-bcache@vger.kernel.org, jianchao.wan9@gmail.com
From:   Zhang Zhen <zhangzhen.email@gmail.com>
Subject: bcache detach lead to xfs force shutdown
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi coly，

We encounted a bcache detach problem, during the io process，the cache 
device become missing.

The io error status returned to xfs， and in some case， the xfs do force 
shutdown.

The dmesg as follows:
Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: IO 
error on writing btree.
Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p44: IO 
error on writing btree.
Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p44: IO 
error on writing btree.
Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p57: IO 
error on writing btree.
Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: IO 
error on writing btree.
Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p57: IO 
error on writing btree.
Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: IO 
error on writing btree.
Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
Feb  2 20:59:23  kernel: XFS (bcache43): metadata I/O error in 
"xfs_buf_iodone_callback_error" at daddr 0x80034658 len 32 error 12
Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
Feb  2 20:59:23  kernel: bcache: bch_cache_set_error() bcache: error on 
004f8aa7-561a-4ba7-bf7b-292e461d3f18:
Feb  2 20:59:23  kernel: journal io error
Feb  2 20:59:23  kernel: bcache: bch_cache_set_error() , disabling caching
Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
Feb  2 20:59:23  kernel: bcache: conditional_stop_bcache_device() 
stop_when_cache_set_failed of bcache43 is "auto" and cache is clean, 
keep it alive.
Feb  2 20:59:23  kernel: XFS (bcache43): metadata I/O error in 
"xlog_iodone" at daddr 0x400123e60 len 64 error 12
Feb  2 20:59:23  kernel: XFS (bcache43): xfs_do_force_shutdown(0x2) 
called from line 1298 of file fs/xfs/xfs_log.c. Return address = 
00000000c1c8077f
Feb  2 20:59:23  kernel: XFS (bcache43): Log I/O Error Detected. 
Shutting down filesystem
Feb  2 20:59:23  kernel: XFS (bcache43): Please unmount the filesystem 
and rectify the problem(s)


We checked the code, the error status is returned in 
cached_dev_make_request and closure_bio_submit function.

1180 static blk_qc_t cached_dev_make_request(struct request_queue *q,
1181                     struct bio *bio)
1182 {
1183     struct search *s;
1184     struct bcache_device *d = bio->bi_disk->private_data;
1185     struct cached_dev *dc = container_of(d, struct cached_dev, disk);
1186     int rw = bio_data_dir(bio);
1187
1188     if (unlikely((d->c && test_bit(CACHE_SET_IO_DISABLE, 
&d->c->flags)) ||
1189              dc->io_disable)) {
1190         bio->bi_status = BLK_STS_IOERR;
1191         bio_endio(bio);
1192         return BLK_QC_T_NONE;
1193     }

  901 static inline void closure_bio_submit(struct cache_set *c,
  902                       struct bio *bio,
  903                       struct closure *cl)
  904 {
  905     closure_get(cl);
  906     if (unlikely(test_bit(CACHE_SET_IO_DISABLE, &c->flags))) {
  907         bio->bi_status = BLK_STS_IOERR;
  908         bio_endio(bio);
  909         return;
  910     }
  911     generic_make_request(bio);
  912 }

Can the cache set detached and don't return error status to fs?
