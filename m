Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75450210DF8
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Jul 2020 16:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730264AbgGAOsZ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Jul 2020 10:48:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:33414 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbgGAOsZ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Jul 2020 10:48:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9FCFBAEC2;
        Wed,  1 Jul 2020 14:48:22 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 88D47DA781; Wed,  1 Jul 2020 16:48:06 +0200 (CEST)
Date:   Wed, 1 Jul 2020 16:48:06 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        dm-devel@redhat.com, cgroups@vger.kernel.org,
        linux-block@vger.kernel.org, drbd-dev@tron.linbit.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] writeback: remove bdi->congested_fn
Message-ID: <20200701144805.GC27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        dm-devel@redhat.com, cgroups@vger.kernel.org,
        linux-block@vger.kernel.org, drbd-dev@tron.linbit.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20200701090622.3354860-1-hch@lst.de>
 <20200701090622.3354860-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701090622.3354860-5-hch@lst.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Jul 01, 2020 at 11:06:22AM +0200, Christoph Hellwig wrote:
> Except for pktdvd, the only places setting congested bits are file
> systems that allocate their own backing_dev_info structures.  And
> pktdvd is a deprecated driver that isn't useful in stack setup
> either.  So remove the dead congested_fn stacking infrastructure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/drbd/drbd_main.c   | 59 --------------------------------
>  drivers/md/bcache/request.c      | 43 -----------------------
>  drivers/md/bcache/super.c        |  1 -
>  drivers/md/dm-cache-target.c     | 19 ----------
>  drivers/md/dm-clone-target.c     | 15 --------
>  drivers/md/dm-era-target.c       | 15 --------
>  drivers/md/dm-raid.c             | 12 -------
>  drivers/md/dm-table.c            | 37 +-------------------
>  drivers/md/dm-thin.c             | 16 ---------
>  drivers/md/dm.c                  | 33 ------------------
>  drivers/md/dm.h                  |  1 -
>  drivers/md/md-linear.c           | 24 -------------
>  drivers/md/md-multipath.c        | 23 -------------
>  drivers/md/md.c                  | 23 -------------
>  drivers/md/md.h                  |  4 ---
>  drivers/md/raid0.c               | 16 ---------
>  drivers/md/raid1.c               | 31 -----------------
>  drivers/md/raid10.c              | 26 --------------
>  drivers/md/raid5.c               | 25 --------------

For the btrfs bits

>  fs/btrfs/disk-io.c               | 23 -------------

Acked-by: David Sterba <dsterba@suse.com>
