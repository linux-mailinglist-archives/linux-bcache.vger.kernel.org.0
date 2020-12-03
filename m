Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8C52CD299
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Dec 2020 10:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbgLCJd4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 3 Dec 2020 04:33:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36565 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728912AbgLCJdz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 3 Dec 2020 04:33:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606987949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jmel3tjqsc7Vgh83Ue1t0WC/6y10c9bSGUCqUms/GTA=;
        b=SA955Vg9pU/nas6chvuaaMkLB99bJuAz3UOZo6h4SHZgH92omw8FOAWIn+8RXLS8yqjI7n
        flKn8awGYUKrVpK2y2Wf3GnuVKzhEhLiNGogs0Gq+YPvyI6SKQAzWLwsPKzZdrNqgjXRWH
        bHv2ti+Jy0c7Un8aYMV6zSEkp6yYyYQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-oQcaGzWtP5-v7yXp30SHvg-1; Thu, 03 Dec 2020 04:32:25 -0500
X-MC-Unique: oQcaGzWtP5-v7yXp30SHvg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D5D9185E497;
        Thu,  3 Dec 2020 09:32:24 +0000 (UTC)
Received: from T590 (ovpn-13-173.pek2.redhat.com [10.72.13.173])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 627CB1899A;
        Thu,  3 Dec 2020 09:32:10 +0000 (UTC)
Date:   Thu, 3 Dec 2020 17:32:01 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Coly Li <colyli@suse.de>, Song Liu <song@kernel.org>,
        dm-devel@redhat.com, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 3/9] block: store a block_device pointer in struct bio
Message-ID: <20201203093201.GC633702@T590>
References: <20201201165424.2030647-1-hch@lst.de>
 <20201201165424.2030647-4-hch@lst.de>
 <20201203063941.GA629758@T590>
 <20201203071055.GA633702@T590>
 <20201203082951.GA15581@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203082951.GA15581@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Dec 03, 2020 at 09:29:51AM +0100, Christoph Hellwig wrote:
> On Thu, Dec 03, 2020 at 03:10:55PM +0800, Ming Lei wrote:
> > On Thu, Dec 03, 2020 at 02:40:04PM +0800, Ming Lei wrote:
> > > On Tue, Dec 01, 2020 at 05:54:18PM +0100, Christoph Hellwig wrote:
> > > > Replace the gendisk pointer in struct bio with a pointer to the newly
> > > > improved struct block device.  From that the gendisk can be trivially
> > > > accessed with an extra indirection, but it also allows to directly
> > > > look up all information related to partition remapping.
> > > 
> > > The extra indirection is often done in fast path, so just wondering why
> > > you don't consider to embed gendisk into block_device? Then the extra
> > > indirection can be avoided.
> > 
> > oops, that is only possible for disk, and indirection is still needed
> > for partitions.
> 
> I looked into that, but given that the block device is allocated as part
> of the inode we'd need to tell ->alloc_inode if we want to allocate the
> small inode without the gendisk, or the large one with it which doesn't
> work with the current interface.

I guess it could be done without fs code change, because now block device is
always allocated by bdev_alloc() since 22ae8ce8b892("block: simplify bdev/disk
lookup in blkdev_get"). And one manual inode allocation with a bit duplication
from new_inode_pseudo() should be fine:

	allocate big inode for disk, and small for partition
	inode_init_always(sb, inode);
    if (inode) {
            spin_lock(&inode->i_lock);
            inode->i_state = 0;
            spin_unlock(&inode->i_lock);
            INIT_LIST_HEAD(&inode->i_sb_list);
			inode_sb_list_add(inode);
    }

> Beause the hd_struct is gone we're
> still not using more structures in the I/O path than we did before.

Indeed, and block_device instance is often cached in IO path.


thanks,
Ming

