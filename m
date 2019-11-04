Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F40EE789
	for <lists+linux-bcache@lfdr.de>; Mon,  4 Nov 2019 19:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbfKDSmV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 4 Nov 2019 13:42:21 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43271 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728377AbfKDSmU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Nov 2019 13:42:20 -0500
Received: by mail-qt1-f196.google.com with SMTP id l24so7160299qtp.10;
        Mon, 04 Nov 2019 10:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sEseK7rUIua31dfTM0MrVVdwejEK2arCI2kack4UXRI=;
        b=pjIabtGEseDUarzOCYLgDCwRqkYJ36wuaijAJoBjBphHPc85mt3DmboOrn9rKkcr1j
         kgVZDjk78rrYEsxp4aLBvLZq3VL23R0e99WaASg4+ILDyuL97CDSwA/TQtt2omjv8VDJ
         jVE8kcZ1QVuZ1JCwa7d+v4GaBcaBGdOU2SPYCGsyhqVYCZWALopMhR3Qb0eSr+209dtT
         UduEWyJPa82ykfbZnlKIl7OnfqwJq/mtHG7p+TcP5vcKRMzOV+yK/NKOUa1p6XlvgwgS
         JhKvN6PTawRrIm6x59yDmiON+oFfHIe/Joc3j1UKTeAC99qdUSHvaoyb6rb9bqRjIeZR
         +pcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sEseK7rUIua31dfTM0MrVVdwejEK2arCI2kack4UXRI=;
        b=ZpRlj3ABMuIWmdCbGTr3oqIF7HZXANQdJKGoI5ti6nQVA9wgN7R0eYGp71ek+foO8M
         hh03UDZi1nbZYSwQQEo3bYw4DOT/aOt7NLS7Z3q/cKc0NbWae/S57Z2K2zb+yh1HKDjo
         AhxTCvcO4qx0Ytl5y6VUyHAisEywwX06idlaVy45dqaIz6VR5a8NYA+U+J685kKegUo9
         swuK2c2XhGoEfXPFYxq1RIwwh9WaOM0YVpbU7YswIIgi1eKyV91wHsDhRCB5S/1jv9YC
         U9OKUrtz20IkvlZan7p0qV747z3ksFH2FIqdIXQT/vxj6op64/2nAEj9gr/Lj6DzD2K7
         Ab6Q==
X-Gm-Message-State: APjAAAUWSghEPN7g0ZSFZXiCopuggEVvQpMeOz39Cl1mi9UJHasbs06h
        d89rGBTGGevi4wfQ44SPVA==
X-Google-Smtp-Source: APXvYqwIcUUUIML523nErBcTIsdXb3cbr2Y/8+66qVi3T+zFkQ+CsjoNxFPmZp/OYNfo/SEAVw83Lg==
X-Received: by 2002:ac8:2fba:: with SMTP id l55mr14080384qta.167.1572892939748;
        Mon, 04 Nov 2019 10:42:19 -0800 (PST)
Received: from kmo-pixel ([65.183.151.50])
        by smtp.gmail.com with ESMTPSA id i4sm7264030qtp.57.2019.11.04.10.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 10:42:19 -0800 (PST)
Date:   Mon, 4 Nov 2019 13:42:17 -0500
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Keith Busch <kbusch@kernel.org>,
        linux-bcache@vger.kernel.org
Subject: Re: [PATCH V4] block: optimize for small block size IO
Message-ID: <20191104184217.GD8984@kmo-pixel>
References: <20191102072911.24817-1-ming.lei@redhat.com>
 <20191104181403.GA8984@kmo-pixel>
 <20191104181541.GA21116@infradead.org>
 <20191104181742.GC8984@kmo-pixel>
 <f7fab4e0-58e4-76e4-a503-bb535b2a3da6@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7fab4e0-58e4-76e4-a503-bb535b2a3da6@kernel.dk>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Nov 04, 2019 at 11:23:42AM -0700, Jens Axboe wrote:
> On 11/4/19 11:17 AM, Kent Overstreet wrote:
> > On Mon, Nov 04, 2019 at 10:15:41AM -0800, Christoph Hellwig wrote:
> >> On Mon, Nov 04, 2019 at 01:14:03PM -0500, Kent Overstreet wrote:
> >>> On Sat, Nov 02, 2019 at 03:29:11PM +0800, Ming Lei wrote:
> >>>> __blk_queue_split() may be a bit heavy for small block size(such as
> >>>> 512B, or 4KB) IO, so introduce one flag to decide if this bio includes
> >>>> multiple page. And only consider to try splitting this bio in case
> >>>> that the multiple page flag is set.
> >>>
> >>> So, back in the day I had an alternative approach in mind: get rid of
> >>> blk_queue_split entirely, by pushing splitting down to the request layer - when
> >>> we map the bio/request to sgl, just have it map as much as will fit in the sgl
> >>> and if it doesn't entirely fit bump bi_remaining and leave it on the request
> >>> queue.
> >>>
> >>> This would mean there'd be no need for counting segments at all, and would cut a
> >>> fair amount of code out of the io path.
> >>
> >> I thought about that to, but it will take a lot more effort.  Mostly
> >> because md/dm heavily rely on splitting as well.  I still think it is
> >> worthwhile, it will just take a significant amount of time and we
> >> should have the quick improvement now.
> > 
> > We can do it one driver at a time - driver sets a flag to disable
> > blk_queue_split(). Obvious one to do first would be nvme since that's where it
> > shows up the most.
> > 
> > And md/md do splitting internally, but I'm not so sure they need
> > blk_queue_split().
> 
> I'm a big proponent of doing something like that instead, but it is a
> lot of work. I absolutely hate the splitting we're doing now, even
> though the original "let's work as hard as we add add page time to get
> things right" was pretty abysmal as well.

Last I looked I don't think it was going to be that bad, just needed a bit of
finesse. We just need to be able to partially process a request in e.g.
nvme_map_data(), and blk_rq_map_sg() needs to be modified to only map as much as
will fit instead of popping an assertion.
