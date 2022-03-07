Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8FFF4CF308
	for <lists+linux-bcache@lfdr.de>; Mon,  7 Mar 2022 08:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235995AbiCGH5g (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 7 Mar 2022 02:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbiCGH5f (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 7 Mar 2022 02:57:35 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE78F60DA8
        for <linux-bcache@vger.kernel.org>; Sun,  6 Mar 2022 23:56:41 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id e13so13059928plh.3
        for <linux-bcache@vger.kernel.org>; Sun, 06 Mar 2022 23:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:to:subject:references
         :in-reply-to:content-transfer-encoding;
        bh=a+MN8ldC3EeaBfi4wXLZPMAiFb5TmFwK1fIlCBzim4c=;
        b=LSCj3P5MTm1bXX5S7vf/YRNe3utf/kUkR/wgAjQEiXzZmeA2xuuYHvjn4L3VQ8i2bw
         1QRn/Zr32kI8H71hriJ462I7XQKiLrdB8HTqkiOQ8JFcbaevegh/1RcBqkWka6/mQtuz
         qCrCxJy02M6oL119W1owQcnIT5T9gGLSwo07dgvk2neSvQpIEeRNup52NXIOS7Iiazlw
         BnEKK+xl8i+beduYqNjGdGobRsWpGQclow7iR4ivcPvyJY2psHc5vqgDXiTF8GgItHk1
         luRo5kgrLMPm9nCortia4HjCHIAP/NriCmd4BeneV10MdOxqeRit9X836rtDGJ8fO2SA
         qA0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from:to
         :subject:references:in-reply-to:content-transfer-encoding;
        bh=a+MN8ldC3EeaBfi4wXLZPMAiFb5TmFwK1fIlCBzim4c=;
        b=E03opfjqU6PwQY3uJJnbR7Ftkb3cfqENC611t8H8Sn/BZJ0Tx+2++veUddWTtbN9UU
         WinPJ9Ek3RZAmanXqd1Mi8lvemBP7L8cwGvP5vTOK7TNyCC6LBbxZ6t2U/RjzB39dghZ
         KkRisC+dL0aHXq6hLEligS1peaFp2hSIUu44yASV5TurTh96VcbNWvXTy2OhKk+YrX5d
         qseKdE+hdKwRuoH+fEJop2fItuzM4wSdmbxuLG2f7PcRCd6lyyBwrxJVxMncZkqsJVOU
         oQmp8N5DDqwuijK5CFFnbp4RyvNwyC3nMiuIa9WHIP+TkRKdpsR36s3UO5qwxDq18Zk4
         trpg==
X-Gm-Message-State: AOAM533Zo2MWvcHHIjr8t5c1yDWzs4sd+5frgrP1Kd/ImFiYGgmczGS3
        HqdmVIxvNFxvNEbQ9FC3zFg=
X-Google-Smtp-Source: ABdhPJyDFyKsOouvnaNyGWDFsf7f04vLifBmdGCOTShxVXaMRxEzVWtq3kUgmjw9/FChmbPcSChoYg==
X-Received: by 2002:a17:903:1011:b0:151:bd0e:bc5c with SMTP id a17-20020a170903101100b00151bd0ebc5cmr10856409plb.79.1646639801329;
        Sun, 06 Mar 2022 23:56:41 -0800 (PST)
Received: from [172.20.104.60] ([162.219.34.248])
        by smtp.gmail.com with ESMTPSA id q2-20020a056a00084200b004f0fea7d3c8sm15035703pfk.26.2022.03.06.23.56.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Mar 2022 23:56:41 -0800 (PST)
Message-ID: <bff3b87d-d8e7-1395-f431-445d98716906@gmail.com>
Date:   Mon, 7 Mar 2022 15:56:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
From:   zhangzhen.email@gmail.com
To:     Coly Li <colyli@suse.de>, Nix <nix@esperi.org.uk>,
        linux-bcache@vger.kernel.org, jianchao.wan9@gmail.com
Subject: Re: bcache detach lead to xfs force shutdown
References: <e6c45b07-769c-575b-0d9c-929aba6ab21a@gmail.com>
 <da192278-8d05-2cce-0301-abafeff3c2fb@suse.de>
 <252588da-1e44-71d9-95a0-39a70c5d3f42@gmail.com>
 <6cab50d8-8771-8b6f-cd09-d318fc3986d3@suse.de>
 <055868d2-1363-da7f-ff4a-d232884d35b9@gmail.com>
 <81a09386-1c4b-810c-a387-c636a0c3d5a5@suse.de>
In-Reply-To: <81a09386-1c4b-810c-a387-c636a0c3d5a5@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



On 3/4/22 4:42 PM, Coly Li <colyli@suse.de> wrote:
> On 3/4/22 4:22 PM, Zhang Zhen wrote:
> >
> > On 3/2/22 5:19 PM, Coly Li wrote:
> >> On 2/23/22 8:26 PM, Zhang Zhen wrote:
> >>>
> >>> 在 2022/2/23 下午5:03, Coly Li 写道:
> >>>> On 2/21/22 5:33 PM, Zhang Zhen wrote:
> >>>>> Hi coly，
> >>>>>
> >>>>> We encounted a bcache detach problem, during the io process，the 
> >>>>> cache device become missing.
> >>>>>
> >>>>> The io error status returned to xfs， and in some case， the xfs 
> >>>>> do force shutdown.
> >>>>>
> >>>>> The dmesg as follows:
> >>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: 
> >>>>> IO error on writing btree.
> >>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p44: 
> >>>>> IO error on writing btree.
> >>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p44: 
> >>>>> IO error on writing btree.
> >>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p57: 
> >>>>> IO error on writing btree.
> >>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: 
> >>>>> IO error on writing btree.
> >>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p57: 
> >>>>> IO error on writing btree.
> >>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: 
> >>>>> IO error on writing btree.
> >>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
> >>>>> Feb  2 20:59:23  kernel: XFS (bcache43): metadata I/O error in 
> >>>>> "xfs_buf_iodone_callback_error" at daddr 0x80034658 len 32 error 12
> >>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
> >>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
> >>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
> >>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
> >>>>> Feb  2 20:59:23  kernel: bcache: bch_cache_set_error() bcache: 
> >>>>> error on 004f8aa7-561a-4ba7-bf7b-292e461d3f18:
> >>>>> Feb  2 20:59:23  kernel: journal io error
> >>>>> Feb  2 20:59:23  kernel: bcache: bch_cache_set_error() , disabling 
> >>>>> caching
> >>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
> >>>>> Feb  2 20:59:23  kernel: bcache: conditional_stop_bcache_device() 
> >>>>> stop_when_cache_set_failed of bcache43 is "auto" and cache is 
> >>>>> clean, keep it alive.
> >>>>> Feb  2 20:59:23  kernel: XFS (bcache43): metadata I/O error in 
> >>>>> "xlog_iodone" at daddr 0x400123e60 len 64 error 12
> >>>>> Feb  2 20:59:23  kernel: XFS (bcache43): 
> >>>>> xfs_do_force_shutdown(0x2) called from line 1298 of file 
> >>>>> fs/xfs/xfs_log.c. Return address = 00000000c1c8077f
> >>>>> Feb  2 20:59:23  kernel: XFS (bcache43): Log I/O Error Detected. 
> >>>>> Shutting down filesystem
> >>>>> Feb  2 20:59:23  kernel: XFS (bcache43): Please unmount the 
> >>>>> filesystem and rectify the problem(s)
> >>>>>
> >>>>>
> >>>>> We checked the code, the error status is returned in 
> >>>>> cached_dev_make_request and closure_bio_submit function.
> >>>>>
> >>>>> 1180 static blk_qc_t cached_dev_make_request(struct request_queue *q,
> >>>>> 1181                     struct bio *bio)
> >>>>> 1182 {
> >>>>> 1183     struct search *s;
> >>>>> 1184     struct bcache_device *d = bio->bi_disk->private_data;
> >>>>> 1185     struct cached_dev *dc = container_of(d, struct 
> >>>>> cached_dev, disk);
> >>>>> 1186     int rw = bio_data_dir(bio);
> >>>>> 1187
> >>>>> 1188     if (unlikely((d->c && test_bit(CACHE_SET_IO_DISABLE, 
> >>>>> &d->c->flags)) ||
> >>>>> 1189              dc->io_disable)) {
> >>>>> 1190         bio->bi_status = BLK_STS_IOERR;
> >>>>> 1191         bio_endio(bio);
> >>>>> 1192         return BLK_QC_T_NONE;
> >>>>> 1193     }
> >>>>>
> >>>>>  901 static inline void closure_bio_submit(struct cache_set *c,
> >>>>>  902                       struct bio *bio,
> >>>>>  903                       struct closure *cl)
> >>>>>  904 {
> >>>>>  905     closure_get(cl);
> >>>>>  906     if (unlikely(test_bit(CACHE_SET_IO_DISABLE, &c->flags))) {
> >>>>>  907         bio->bi_status = BLK_STS_IOERR;
> >>>>>  908         bio_endio(bio);
> >>>>>  909         return;
> >>>>>  910     }
> >>>>>  911     generic_make_request(bio);
> >>>>>  912 }
> >>>>>
> >>>>> Can the cache set detached and don't return error status to fs?
> >>>>
> >>>>
> >>>> Hi Zhang,
> >>>>
> >>>>
> >>>> What is your kernel version and where do you get the kernel?
> >>>> My kernel version is 4.18 of Centos.
> >>> The code of this part is same with upstream kernel.
> >>>> It seems like an as designed behavior, could you please describe 
> >>>> more detail about the operation sequence?
> >>>>
> >>> Yes, i think so too.
> >>> The reproduce opreation as follows:
> >>> 1. mount a bcache disk with xfs
> >>>
> >>> /dev/bcache1 on /media/disk1 type xfs
> >>>
> >>> 2. run ls in background
> >>> #!/bin/bash
> >>>
> >>> while true
> >>> do
> >>>   echo 2 > /proc/sys/vm/drop_caches
> >>>   ls -R /media/disk1 > /dev/null
> >>> done
> >>>
> >>>
> >>> 3. remove cache disk sdc
> >>> echo 1 >/sys/block/sdc/device/delete
> >>>
> >>> 4. dmesg should get xfs error
> >>>
> >>> I write a patch to improve，please help to review it, thanks.
> >
> >>
> >> Hold on. Why do you think it should be fixed? As I said, it is 
> >> as-designed behavior.
> >>
> > We use bcache in writearound mode, just cache read io.
> > Currently, bcache return io error during detach, randomly lead to
> > xfs force shutdown.
> >
> > After bcache auto detach finished, some dir read write normaly, but
> > the others can't read write because of xfs force shutdown.
> > This inconsistency confuses filesystem users.
> 
> 
> Hi Zhen and Nix,
> 
> OK, I come to realize the motivation. Yes you are right, this is an 
> awkward issue and good to be fixed.
> 
Hi Coly,

So you will pick this patch into your tree ？
> 
> Coly Li
> 
> 
