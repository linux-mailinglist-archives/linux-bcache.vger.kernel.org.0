Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0E12A9755
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Nov 2020 15:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgKFOCG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Nov 2020 09:02:06 -0500
Received: from verein.lst.de ([213.95.11.211]:51668 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727251AbgKFOCG (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Nov 2020 09:02:06 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id C704868B02; Fri,  6 Nov 2020 15:02:01 +0100 (CET)
Date:   Fri, 6 Nov 2020 15:02:01 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Stefan Haberland <sth@linux.ibm.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Ilya Dryomov <idryomov@gmail.com>, Song Liu <song@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 06/10] dasd: implement ->set_read_only to hook into
 BLKROSET processing
Message-ID: <20201106140201.GA23087@lst.de>
References: <20201103100018.683694-1-hch@lst.de> <20201103100018.683694-7-hch@lst.de> <20201105205634.GA78869@imap.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105205634.GA78869@imap.linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Nov 05, 2020 at 09:56:47PM +0100, Stefan Haberland wrote:
> > +	/* do not manipulate hardware state for partitions */
> >  	if (bdev_is_partition(bdev))
> > -		// ro setting is not allowed for partitions
> > -		return -EINVAL;
> > -	if (get_user(intval, (int __user *)argp))
> > -		return -EFAULT;
> > +		return 0;
> > +
> >  	base = dasd_device_from_gendisk(bdev->bd_disk);
> >  	if (!base)
> >  		return -ENODEV;
> > -	if (!intval && test_bit(DASD_FLAG_DEVICE_RO, &base->flags)) {
> > -		dasd_put_device(base);
> > -		return -EROFS;
> > -	}
> > -	set_disk_ro(bdev->bd_disk, intval);
> 
> 
> While testing this patch I just noticed that when I set a device readonly this is
> not going to be passed on to the partitions on this device any longer.
> 
> This is caused by the removed call to set_disk_ro().
> 
> Is this intentional or was this removed by accident?

It was unintentionally intentional :)

The generic code used already by almost all drivers in mainline only
calls set_device_ro from blkdev_roset, that is it only sets the main
device read-only.  dasd was the outlier here, and I didn't notice it
actually called set_disk_ro instead of set_device_ro.   That being
said I think setting all the partitions read-only as well when the
full device is set read-only makes perfect sense.  I'm just a little
worried it could cause regressions.  Let me prepare a follow on patch
on top of the series that switches to that behavior.
