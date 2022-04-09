Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4D84FA0FC
	for <lists+linux-bcache@lfdr.de>; Sat,  9 Apr 2022 03:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiDIBUL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 8 Apr 2022 21:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiDIBUK (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 8 Apr 2022 21:20:10 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3346398
        for <linux-bcache@vger.kernel.org>; Fri,  8 Apr 2022 18:18:05 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id i20so2083288wrb.13
        for <linux-bcache@vger.kernel.org>; Fri, 08 Apr 2022 18:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=c+qJKM7J9Hyuvgc8Iw0NOV2vT4VMHiF2TdLKvkh6vNY=;
        b=LmhAJKwIbS9TsF8xmscinm53JZNv6TAn+zeljtfNvaey856TJiyv+Nl7RelaliDvNY
         l7kx6UZ4dGLTQ/8pz7EH0CVOUYfPrK2XC5/8U2gNa/wwmPrM+pFrIeQF4YOErq8WE2BZ
         lRRs+w0ZvuQbblm7e9o06SqqsB35SA8OzXGBhJzTu/Y8xgwbVZ2ou57mrppUQErt4pf3
         k+ODVtxMovmSxH1nX++iTyYEBOtE4iNNB1VPUmTq+FM3Jxa1VaZeH3e9NXoc1IKiTDvZ
         xyljPykDghsY5RHQCO/MSlo0FRmA6q/vWht3iHz10YRzcFO5l1R0wo/zv26F6C6KEuRD
         Jmsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=c+qJKM7J9Hyuvgc8Iw0NOV2vT4VMHiF2TdLKvkh6vNY=;
        b=wG4Sun/06Z1Ss6iryHng6OaR140wsnBOPXUhFnqqVHzIEfSnbOXoN8HLU8T2DNdj44
         epYcOBeNukJXeHgpLo3xU5kvwuX9f93Wgt1lbjSGyB8iOH4KiYvGTUC7k+chMvgqMUXU
         OKTfxGLudq0JkR4Vids/Ct2I5bThcyPElbCsbqzsrVK6WiGUFfvTONxv0hz2AmdRck7I
         59OIFVfOM/9RnL5ET10Y5azEe2dpz6BOoWlW1R17IvXirktd7v/hDjvM8xDCRmj3uPya
         UhEKRTuiz0cJYHZcl/yFZWc8qGL1srReW4RJNCst29A3N5XoIAKVy/62qJVcbHlFLDfO
         cBTA==
X-Gm-Message-State: AOAM532OFqdso31KvCrH/QrKnHhnmLtnKfODd6l7jkF0iSvXVQxbmNfQ
        4kJXM/x8juZ4K+OsoMl55VUlI/e0KfNSQ+GMn8Q=
X-Google-Smtp-Source: ABdhPJysgJ5Sq3lnRwyxlGRcRXZnAxGXRYlbnx65Mkg6M5T6B5gOP4h6viwwaa4U3wH4rwUtWY8+m6N5w7e7Sxo6qrw=
X-Received: by 2002:adf:f386:0:b0:207:9e79:4131 with SMTP id
 m6-20020adff386000000b002079e794131mr517262wro.524.1649467084027; Fri, 08 Apr
 2022 18:18:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220327072038.12385-1-lilei@szsandstone.com> <40862b68-e81d-089b-d713-b0e6e2bd7e04@suse.de>
In-Reply-To: <40862b68-e81d-089b-d713-b0e6e2bd7e04@suse.de>
From:   =?UTF-8?B?5p2O56OK?= <noctis.akm@gmail.com>
Date:   Sat, 9 Apr 2022 09:17:51 +0800
Message-ID: <CAMhKsXnLdAjSN00WpCrq4P-3Z6PEf+vp_QfiHcwCLuVH9s5z_Q@mail.gmail.com>
Subject: Re: [PATCH] bcache: remove unnecessary flush_workqueue
To:     Coly Li <colyli@suse.de>
Cc:     kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        Li Lei <lilei@szsandstone.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Coly Li <colyli@suse.de> =E4=BA=8E2022=E5=B9=B44=E6=9C=888=E6=97=A5=E5=91=
=A8=E4=BA=94 00:54=E5=86=99=E9=81=93=EF=BC=9A
>
> On 3/27/22 3:20 PM, Li Lei wrote:
> > All pending works will be drained by destroy_workqueue(), no need to ca=
ll
> > flush_workqueue() explicitly.
> >
> > Signed-off-by: Li Lei <lilei@szsandstone.com>
> > ---
> >   drivers/md/bcache/writeback.c | 5 ++---
> >   1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writebac=
k.c
> > index 9ee0005874cd..2a6d9f39a9b1 100644
> > --- a/drivers/md/bcache/writeback.c
> > +++ b/drivers/md/bcache/writeback.c
> > @@ -793,10 +793,9 @@ static int bch_writeback_thread(void *arg)
> >               }
> >       }
> >
> > -     if (dc->writeback_write_wq) {
> > -             flush_workqueue(dc->writeback_write_wq);
> > +     if (dc->writeback_write_wq)
> >               destroy_workqueue(dc->writeback_write_wq);
> > -     }
> > +
> >       cached_dev_put(dc);
> >       wait_for_kthread_stop();
> >
>
> The above code is from commit 7e865eba00a3 ("bcache: fix potential
> deadlock in cached_def_free()"). I explicitly added extra
> flush_workqueue() was because of workqueue_sysfs_unregister(wq) in
> destory_workqueue().
>
> workqueue_sysfs_unregister() is not simple because it calls
> device_unregister(), and the code path is long. During reboot I am not
> sure whether extra deadlocking issue might be introduced. So the safe
> way is to explicitly call flush_workqueue() firstly to wait for all
> kwork finished, then destroy it.
>
> It has been ~3 years passed, now I am totally OK with your above change.
> But could you please test your patch with lockdep enabled, and see
> whether there is no lock warning observed? Then I'd like to add it into
> my test directory.
>

OK=EF=BC=8CI will test this scenario.
