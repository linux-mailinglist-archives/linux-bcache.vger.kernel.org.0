Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98312A1D38
	for <lists+linux-bcache@lfdr.de>; Sun,  1 Nov 2020 11:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgKAK1k (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 1 Nov 2020 05:27:40 -0500
Received: from verein.lst.de ([213.95.11.211]:58311 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgKAK1k (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 1 Nov 2020 05:27:40 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 56FF56736F; Sun,  1 Nov 2020 11:27:36 +0100 (CET)
Date:   Sun, 1 Nov 2020 11:27:35 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Ilya Dryomov <idryomov@gmail.com>,
        Song Liu <song@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 02/11] mtip32xx: return -ENOTTY for all unhanled ioctls
Message-ID: <20201101102735.GA26447@lst.de>
References: <20201031085810.450489-1-hch@lst.de> <20201031085810.450489-3-hch@lst.de> <f128e8bb-7ce4-b8f4-80cb-1afab503887c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f128e8bb-7ce4-b8f4-80cb-1afab503887c@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sat, Oct 31, 2020 at 08:58:52AM -0600, Jens Axboe wrote:
> On 10/31/20 2:58 AM, Christoph Hellwig wrote:
> > -ENOTTY is the convention for "driver does not support this ioctl".
> > Use it properly in mtip32xx instead of the bogys -EINVAL.
> 
> While that's certainly true, there is a risk in making a change like this
> years after the fact. Not that I expect there are any mtip32xx users
> left at this point, but...

-ENOTTY is what most drivers return.  That being said we can keep the
old behavior, so if you prepfer that I can respin to do that.
