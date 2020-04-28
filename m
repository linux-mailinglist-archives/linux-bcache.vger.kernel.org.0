Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC791BCA5C
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Apr 2020 20:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730227AbgD1SiW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 28 Apr 2020 14:38:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55300 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730617AbgD1SiW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 28 Apr 2020 14:38:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588099100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bgJAyyf5GmHh28MNCDwhUPfnJXVqZHhoCh5pJxPYXEk=;
        b=gYSywT8kzOL4svLSxY8F7tcpS1laADoViHefr30DFqVUfInxmSYa/Zwf7qtWRn25CTMGWz
        Neb3ZVKm/l0SD4yNBvKl5DStYGu3m843hcSCdS/jlLmdy/7giYZinCMiufRI0oJkUFdJD+
        mhNh0UvzE1sKg/i6rIeKYrZjCgTjKAA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-6YfndAHJOnGV5Pry9M067A-1; Tue, 28 Apr 2020 14:38:18 -0400
X-MC-Unique: 6YfndAHJOnGV5Pry9M067A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE497800D24;
        Tue, 28 Apr 2020 18:38:16 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DFD261002388;
        Tue, 28 Apr 2020 18:38:13 +0000 (UTC)
Date:   Tue, 28 Apr 2020 14:38:13 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-bcache@vger.kernel.org
Subject: Re: [PATCH 2/3] dm: remove the make_request_fn check in
 device_area_is_invalid
Message-ID: <20200428183812.GA17609@redhat.com>
References: <20200425075336.721021-1-hch@lst.de>
 <20200425075336.721021-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200425075336.721021-3-hch@lst.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sat, Apr 25 2020 at  3:53am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Think it'd be useful to add a commit message like you did for revert
commit f01b411f41f91fc3196eae4317cf8b4d872830a6 , e.g.:

We can't have queues without a make_request_fn any more (and the loop
device uses blk-mq these days anyway..).

But that aside:

Acked-by: Mike Snitzer <snitzer@redhat.com>

Thanks.

> ---
>  drivers/md/dm-table.c | 17 -----------------
>  1 file changed, 17 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 0a2cc197f62b4..8277b959e00bd 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -279,7 +279,6 @@ static struct dm_dev_internal *find_device(struct list_head *l, dev_t dev)
>  static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>  				  sector_t start, sector_t len, void *data)
>  {
> -	struct request_queue *q;
>  	struct queue_limits *limits = data;
>  	struct block_device *bdev = dev->bdev;
>  	sector_t dev_size =
> @@ -288,22 +287,6 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>  		limits->logical_block_size >> SECTOR_SHIFT;
>  	char b[BDEVNAME_SIZE];
>  
> -	/*
> -	 * Some devices exist without request functions,
> -	 * such as loop devices not yet bound to backing files.
> -	 * Forbid the use of such devices.
> -	 */
> -	q = bdev_get_queue(bdev);
> -	if (!q || !q->make_request_fn) {
> -		DMWARN("%s: %s is not yet initialised: "
> -		       "start=%llu, len=%llu, dev_size=%llu",
> -		       dm_device_name(ti->table->md), bdevname(bdev, b),
> -		       (unsigned long long)start,
> -		       (unsigned long long)len,
> -		       (unsigned long long)dev_size);
> -		return 1;
> -	}
> -
>  	if (!dev_size)
>  		return 0;
>  
> -- 
> 2.26.1
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

