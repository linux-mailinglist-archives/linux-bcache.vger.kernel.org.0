Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FF82DE9C5
	for <lists+linux-bcache@lfdr.de>; Fri, 18 Dec 2020 20:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733201AbgLRT3Q (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 18 Dec 2020 14:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgLRT3N (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 18 Dec 2020 14:29:13 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3155AC0617B0
        for <linux-bcache@vger.kernel.org>; Fri, 18 Dec 2020 11:28:33 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id c14so2114024qtn.0
        for <linux-bcache@vger.kernel.org>; Fri, 18 Dec 2020 11:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=haNplt5dftsxM3wc70FLKt+NXshKmr1T2L9Oc8IJD9Y=;
        b=ZZbgtWnosuYXL9U4aR0lgTUFxetWEJDkmzgn85UO3ubGDkJjV2bUunkLbr546NKet9
         VzU2tzLeMu1/rvZYTGoCoI9pdhFxx7n+d5d6Xe4GgrIMRVKvWxrdRZVYC4Hwrdt/u1mo
         8bK1o6Vyo99MGNsPH7Mj99K6kksVWwwOq7yUHN+76R0jk5X5K5QRsrbmt1GSu97DhiHA
         z/YWl7XxqrBfAPuMbuAUcgq+jIB5BnOfgqMEftrm0F2DufxGcOc9vHQq04pEXIY7Si3I
         e1T1okD8e2svJ8v1kx9RfXi4lNWAA75FX2A1mz7iG5IBewi/a1XOTWtBDRv5hGv1b8ZG
         JEag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=haNplt5dftsxM3wc70FLKt+NXshKmr1T2L9Oc8IJD9Y=;
        b=s7zeDhPH82Hz5vS2YEfZMSwsiaz8hQvn1mxwnt7sm19dbh77PpogAbJBdLpYcFCaZW
         sESuBPAzbyBWv3ljL+/+yyyMzNbmk7+TJFlNMQloko6ItiliI6mgJwFn/Fshnojc0Ykh
         Pz+1nRoYF9LKAX2PFFfawTS/0mz/X9gYo95i5rv5+v+uf4FuqhW7ZztVktDbZRgwhCY5
         lpzvgngxNPHvP28qZzrWsXe65b3OfInFNwwjoAC3Q57zTy8oZaj6vWf/pSAC0praSKNA
         8RoxALy6b8J9RpE4AKgH/wRqmz/JfwT21YH/yD8oU1lOpWV88yeCGaqGlJ8twjjcS01S
         NVOw==
X-Gm-Message-State: AOAM533VB5w6Zapqa6g7MCpIMqq4Qfrp7FjKoNsq0600EaQ7H0yQYaxa
        4gXdn9bM4RmQcbajy+bXig==
X-Google-Smtp-Source: ABdhPJxjlctZrkx3mAyeveRhoLwlqs7JMKnVyH/L1gNokx0nPBPnPwR1achY0YwrEXT9mFhL3Sx71g==
X-Received: by 2002:ac8:5ccc:: with SMTP id s12mr5475943qta.309.1608319712427;
        Fri, 18 Dec 2020 11:28:32 -0800 (PST)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id b6sm6103646qkc.128.2020.12.18.11.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 11:28:31 -0800 (PST)
Date:   Fri, 18 Dec 2020 14:28:30 -0500
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Coly Li <colyli@suse.de>
Cc:     Lin Feng <linf@wangsu.com>, linux-bcache@vger.kernel.org
Subject: Re: Defects about bcache GC
Message-ID: <X90C3q+OHke6OZ5H@moria.home.lan>
References: <5768fb38-743a-42e7-a6b6-a12d7ea9f3f0@wangsu.com>
 <2601f763-405c-b63d-a181-de022ecabaf3@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2601f763-405c-b63d-a181-de022ecabaf3@suse.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, Dec 18, 2020 at 07:52:10PM +0800, Coly Li wrote:
> On 12/18/20 6:35 PM, Lin Feng wrote:
> > Hi all,
> > 
> > I googled a lot but only finding this, my question is if this issue have
> > been fixed or
> > if there are ways to work around?
> > 
> >> On Wed, 28 Jun 2017, Coly Li wrote:
> >>
> >> > On 2017/6/27 下午8:04, tang.junhui@xxxxxxxxxx wrote:
> >> > > Hello Eric, Coly,
> >> > >
> >> > > I use a 1400G SSD device a bcache cache device,
> >> > > and attach with 10 back-end devices,
> >> > > and run random small write IOs,
> >> > > when gc works, It takes about 15 seconds,
> >> > > and the up layer application IOs was suspended at this time,
> >> > > How could we bear such a long time IO stopping?
> >> > > Is there any way we can avoid this problem?
> >> > >
> >> > > I am very anxious about this question, any comment would be valuable.
> >> >
> >> > I encounter same situation too.
> >> > Hmm, I assume there are some locking issue here, to prevent application
> >> > to send request and insert keys in LSM tree, no matter in writeback or
> >> > writethrough mode. This is a lazy and fast response, I need to check
> > the
> >> > code then provide an accurate reply :-)
> >>
> > 
> > I encoutered even worse situation(8TB ssd cached for 4*10 TB disks) as
> > mail extracted above,
> > all usrer IOs are hung during bcache GC runs, my kernel is 4.18, while I
> > tested it with kernel 5.10,
> > it seems that situation is unchaged.
> > 
> > Below are some logs for reference.
> > GC trace events:
> > [Wed Dec 16 15:08:40 2020]   ##48735 [046] .... 1632697.784097:
> > bcache_gc_start: 4ab63029-0c4a-42a8-8f54-e638358c2c6c
> > [Wed Dec 16 15:09:01 2020]   ##48735 [034] .... 1632718.828510:
> > bcache_gc_end: 4ab63029-0c4a-42a8-8f54-e638358c2c6c
> > 
> > and during which iostat shows like:
> > 12/16/2020 03:08:48 PM
> > Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
> > avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> > sdb               0.00     0.50 1325.00   27.00 169600.00   122.00  
> > 251.07     0.32    0.24    0.24    0.02   0.13  17.90
> > sdc               0.00     0.00    0.00    0.00     0.00     0.00    
> > 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> > sdd               0.00     0.00    0.00    0.00     0.00     0.00    
> > 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> > sde               0.00     0.00    0.00    0.00     0.00     0.00    
> > 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> > sdf               0.00     0.00    0.00    0.00     0.00     0.00    
> > 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> > bcache0           0.00     0.00    1.00    0.00     4.00     0.00    
> > 8.00    39.54    0.00    0.00    0.00 1000.00 100.00
> > 
> > # grep . /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/*gc*
> > /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/btree_gc_average_duration_ms:26539
> > 
> > /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/btree_gc_average_frequency_sec:8692
> > 
> > /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/btree_gc_last_sec:6328
> > 
> > /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/btree_gc_max_duration_ms:283405
> > 
> > /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/copy_gc_enabled:1
> > 
> > /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/gc_always_rewrite:1
> 
> I/O hang during GC is as-designed. We have plan to improve, but the I/O
> hang cannot be 100% avoided.

This is something that's entirely fixed in bcachefs - we update bucket sector
counts as keys enter/leave the btree so runtime btree GC is no longer needed.
