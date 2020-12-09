Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05B82D39E3
	for <lists+linux-bcache@lfdr.de>; Wed,  9 Dec 2020 05:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgLIEtJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-bcache@lfdr.de>); Tue, 8 Dec 2020 23:49:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38857 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbgLIEtJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 8 Dec 2020 23:49:09 -0500
Received: from mail-ot1-f69.google.com ([209.85.210.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <dongdong.tao@canonical.com>)
        id 1kmrOr-0001gx-7T
        for linux-bcache@vger.kernel.org; Wed, 09 Dec 2020 04:48:25 +0000
Received: by mail-ot1-f69.google.com with SMTP id x20so293599otk.23
        for <linux-bcache@vger.kernel.org>; Tue, 08 Dec 2020 20:48:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PA0L/fZ0FdycoQ0Pt5PVvbAssW0hPSIaj0d5Ro06HDU=;
        b=t0F085ZdlrRveZzrTnPiCqkbrp/Io5CToiedJ2Gtpv9hD7feTJkOQO/ikMgojFhq8W
         Lhz9TFNylg5/t68EDYOGgTCDRsBu9lFCqHV4kh+6s0UnStK8ncXcuL1+lR5vEFZHUduJ
         I5nA9aSayEzpgxX46uXYkgP3NMGMRtMhh5Z2Ddjvr0ENYyc4FPSI6nFnfEobtRkH84fj
         kMkzPbl4ug3N5Rd6kG9XxVdicGISK+30TK6L8xsPYSTS5pQ23kqHuhLDd3ysAQ5ScLqq
         EdYHdJAOa9Q7hP7tTYeyhXZizfeh6d3lKMzrVDtA7hOg3xKyHDdu6hQPb7F/TWEDhvDL
         W6Zg==
X-Gm-Message-State: AOAM5303si9qpmpInA4m4autssVzypKOUYXMuCntC209lq9D/sjCp7Qw
        C3F1rHxubb0kq7qniOyEmUVq1w/8p1yJFUg4ZFzczsX10K0gqPpHaQtL2NXBqKQw2cqYGcqkxnY
        00cr/Pcxn5jAOd/6tGrFJFoMfLEF/JMCRJJtGBFMAa4wd9CbTI5owzZ2/fA==
X-Received: by 2002:a9d:620f:: with SMTP id g15mr310324otj.361.1607489303693;
        Tue, 08 Dec 2020 20:48:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy/7JVsm4TZTwCoEmiToTTLsiZPGhAgD37BJBqY2i99MjqwGW8RkwDdtuD3yKtjGfkHRGiSqoeP2lVqkZLX19o=
X-Received: by 2002:a9d:620f:: with SMTP id g15mr310312otj.361.1607489303428;
 Tue, 08 Dec 2020 20:48:23 -0800 (PST)
MIME-Version: 1.0
References: <20201103124235.14440-1-tdd21151186@gmail.com> <89b83c00-1117-d114-2c23-7b03fc22966e@easystack.cn>
In-Reply-To: <89b83c00-1117-d114-2c23-7b03fc22966e@easystack.cn>
From:   Dongdong Tao <dongdong.tao@canonical.com>
Date:   Wed, 9 Dec 2020 12:48:12 +0800
Message-ID: <CAJS8hV+UmLFQVhuqUin1Ze6kLtAO7paXH95+9gaiZgM19VZe1A@mail.gmail.com>
Subject: Re: [PATCH] bcache: consider the fragmentation when update the
 writeback rate
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     Dongdong Tao <tdd21151186@gmail.com>, Coly Li <colyli@suse.de>,
        Gavin Guo <gavin.guo@canonical.com>,
        Gerald Yang <gerald.yang@canonical.com>,
        Trent Lloyd <trent.lloyd@canonical.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Dongsheng,

I'm working on it, next step I'm gathering some testing data and
upload (very sorry for the delay...)
Thanks for the comment.
One of the main concerns to alleviate this issue with the writeback
process is that we need to minimize the impact on the client IO
performance.
writeback_percent by default is 10, start writeback when dirty buckets
reached 10 percent might be a bit too aggressive, as the
writeback_cutoff_sync is 70 percent.
So i chose to start the writeback when dirty buckets reached 50
percent so that this patch will only take effect after dirty buckets
percent is above that

Thanks,
Dongdong




On Wed, Dec 9, 2020 at 10:27 AM Dongsheng Yang
<dongsheng.yang@easystack.cn> wrote:
>
>
> 在 2020/11/3 星期二 下午 8:42, Dongdong Tao 写道:
> > From: dongdong tao <dongdong.tao@canonical.com>
> >
> > Current way to calculate the writeback rate only considered the
> > dirty sectors, this usually works fine when the fragmentation
> > is not high, but it will give us unreasonable small rate when
> > we are under a situation that very few dirty sectors consumed
> > a lot dirty buckets. In some case, the dirty bucekts can reached
> > to CUTOFF_WRITEBACK_SYNC while the dirty data(sectors) noteven
> > reached the writeback_percent, the writeback rate will still
> > be the minimum value (4k), thus it will cause all the writes to be
> > stucked in a non-writeback mode because of the slow writeback.
> >
> > This patch will try to accelerate the writeback rate when the
> > fragmentation is high. It calculate the propotional_scaled value
> > based on below:
> > (dirty_sectors / writeback_rate_p_term_inverse) * fragment
> > As we can see, the higher fragmentation will result a larger
> > proportional_scaled value, thus cause a larger writeback rate.
> > The fragment value is calculated based on below:
> > (dirty_buckets *  bucket_size) / dirty_sectors
> > If you think about it, the value of fragment will be always
> > inside [1, bucket_size].
> >
> > This patch only considers the fragmentation when the number of
> > dirty_buckets reached to a dirty threshold(configurable by
> > writeback_fragment_percent, default is 50), so bcache will
> > remain the original behaviour before the dirty buckets reached
> > the threshold.
> >
> > Signed-off-by: dongdong tao <dongdong.tao@canonical.com>
> > ---
> >   drivers/md/bcache/bcache.h    |  1 +
> >   drivers/md/bcache/sysfs.c     |  6 ++++++
> >   drivers/md/bcache/writeback.c | 21 +++++++++++++++++++++
> >   3 files changed, 28 insertions(+)
> >
> > diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> > index 1d57f48307e6..87632f7032b6 100644
> > --- a/drivers/md/bcache/bcache.h
> > +++ b/drivers/md/bcache/bcache.h
> > @@ -374,6 +374,7 @@ struct cached_dev {
> >       unsigned int            writeback_metadata:1;
> >       unsigned int            writeback_running:1;
> >       unsigned char           writeback_percent;
> > +     unsigned char           writeback_fragment_percent;
> >       unsigned int            writeback_delay;
> >
> >       uint64_t                writeback_rate_target;
> > diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> > index 554e3afc9b68..69499113aef8 100644
> > --- a/drivers/md/bcache/sysfs.c
> > +++ b/drivers/md/bcache/sysfs.c
> > @@ -115,6 +115,7 @@ rw_attribute(stop_when_cache_set_failed);
> >   rw_attribute(writeback_metadata);
> >   rw_attribute(writeback_running);
> >   rw_attribute(writeback_percent);
> > +rw_attribute(writeback_fragment_percent);
>
>
> Hi Dongdong and Coly,
>
>      What is the status about this patch? In my opinion, it is a problem
> we need to solve,
>
> but can we just reuse the parameter of writeback_percent, rather than
> introduce a new writeback_fragment_percent?
>
> That means the semantic of writeback_percent will act on dirty data
> percent and dirty bucket percent.
>
> When we found there are dirty buckets more than (c->nbuckets *
> writeback_percent), start the writeback.
>
>
> Thanx
>
> Yang
>
> >   rw_attribute(writeback_delay);
> >   rw_attribute(writeback_rate);
> >
> > @@ -197,6 +198,7 @@ SHOW(__bch_cached_dev)
> >       var_printf(writeback_running,   "%i");
> >       var_print(writeback_delay);
> >       var_print(writeback_percent);
> > +     var_print(writeback_fragment_percent);
> >       sysfs_hprint(writeback_rate,
> >                    wb ? atomic_long_read(&dc->writeback_rate.rate) << 9 : 0);
> >       sysfs_printf(io_errors,         "%i", atomic_read(&dc->io_errors));
> > @@ -308,6 +310,9 @@ STORE(__cached_dev)
> >       sysfs_strtoul_clamp(writeback_percent, dc->writeback_percent,
> >                           0, bch_cutoff_writeback);
> >
> > +     sysfs_strtoul_clamp(writeback_fragment_percent, dc->writeback_fragment_percent,
> > +                         0, bch_cutoff_writeback_sync);
> > +
> >       if (attr == &sysfs_writeback_rate) {
> >               ssize_t ret;
> >               long int v = atomic_long_read(&dc->writeback_rate.rate);
> > @@ -498,6 +503,7 @@ static struct attribute *bch_cached_dev_files[] = {
> >       &sysfs_writeback_running,
> >       &sysfs_writeback_delay,
> >       &sysfs_writeback_percent,
> > +     &sysfs_writeback_fragment_percent,
> >       &sysfs_writeback_rate,
> >       &sysfs_writeback_rate_update_seconds,
> >       &sysfs_writeback_rate_i_term_inverse,
> > diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> > index 3c74996978da..34babc89fdf3 100644
> > --- a/drivers/md/bcache/writeback.c
> > +++ b/drivers/md/bcache/writeback.c
> > @@ -88,6 +88,26 @@ static void __update_writeback_rate(struct cached_dev *dc)
> >       int64_t integral_scaled;
> >       uint32_t new_rate;
> >
> > +     /*
> > +      * We need to consider the number of dirty buckets as well
> > +      * when calculating the proportional_scaled, Otherwise we might
> > +      * have an unreasonable small writeback rate at a highly fragmented situation
> > +      * when very few dirty sectors consumed a lot dirty buckets, the
> > +      * worst case is when dirty_data reached writeback_percent and
> > +      * dirty buckets reached to cutoff_writeback_sync, but the rate
> > +      * still will be at the minimum value, which will cause the write
> > +      * stuck at a non-writeback mode.
> > +      */
> > +     struct cache_set *c = dc->disk.c;
> > +
> > +     if (c->gc_stats.in_use > dc->writeback_fragment_percent && dirty > 0) {
> > +             int64_t dirty_buckets = (c->gc_stats.in_use * c->nbuckets) / 100;
> > +             int64_t fragment = (dirty_buckets *  c->cache->sb.bucket_size) / dirty;
> > +
> > +             proportional_scaled =
> > +             div_s64(dirty, dc->writeback_rate_p_term_inverse) * (fragment);
> > +     }
> > +
> >       if ((error < 0 && dc->writeback_rate_integral > 0) ||
> >           (error > 0 && time_before64(local_clock(),
> >                        dc->writeback_rate.next + NSEC_PER_MSEC))) {
> > @@ -969,6 +989,7 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
> >       dc->writeback_metadata          = true;
> >       dc->writeback_running           = false;
> >       dc->writeback_percent           = 10;
> > +     dc->writeback_fragment_percent  = 50;
> >       dc->writeback_delay             = 30;
> >       atomic_long_set(&dc->writeback_rate.rate, 1024);
> >       dc->writeback_rate_minimum      = 8;
