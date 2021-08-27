Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A25D3FA09A
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Aug 2021 22:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbhH0UaZ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Aug 2021 16:30:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230171AbhH0UaZ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Aug 2021 16:30:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 977CB60FD8;
        Fri, 27 Aug 2021 20:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630096176;
        bh=88bih5eGKB9i2ESLsafMWzYIwyGke7MVW8Rm8LZaCJM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VqgAkXLSFQ2s8YBhV0/BkRbyvjYS7iN8wS3+vPnrfYwjeVZbT3EcOkpsbz+6iOIIg
         K59JPqJADG5mnk2BZMwXfm+2K/QX3GabYmGmJMq75CAhfxkg4e7sYb4W90iqXt4wjY
         CCBcmFMkK/fitfaaSpE06RYuhbvQkR1xSjgZLyqV+ldHSk85VfL/sYK3yuWYBDlle0
         4C9yBY22Kb164kHW1308QMn1cbMYjo7ekT+NZW9nIbbZyeN7dvOl3QZ8uGzlQBiwYO
         xvNRlNxn6B/Q+DSji3QgnHGBcKriUM+BPc6qVP1hIdIo6lvljcLrqIlc4i6mgmBrgk
         KvuManA4RC1Fw==
Date:   Fri, 27 Aug 2021 13:29:32 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     axboe@kernel.dk, colyli@suse.de, kent.overstreet@gmail.com,
        sagi@grimberg.me, vishal.l.verma@intel.com,
        dan.j.williams@intel.com, dave.jiang@intel.com,
        ira.weiny@intel.com, konrad.wilk@oracle.com, roger.pau@citrix.com,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, minchan@kernel.org, ngupta@vflare.org,
        senozhatsky@chromium.org, xen-devel@lists.xenproject.org,
        nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] nvme-multipath: add error handling support for
 add_disk()
Message-ID: <20210827202932.GA82376@dhcp-10-100-145-180.wdc.com>
References: <20210827191809.3118103-1-mcgrof@kernel.org>
 <20210827191809.3118103-4-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827191809.3118103-4-mcgrof@kernel.org>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, Aug 27, 2021 at 12:18:02PM -0700, Luis Chamberlain wrote:
> @@ -479,13 +479,17 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
>  static void nvme_mpath_set_live(struct nvme_ns *ns)
>  {
>  	struct nvme_ns_head *head = ns->head;
> +	int rc;
>  
>  	if (!head->disk)
>  		return;
>  
> -	if (!test_and_set_bit(NVME_NSHEAD_DISK_LIVE, &head->flags)) {
> -		device_add_disk(&head->subsys->dev, head->disk,
> -				nvme_ns_id_attr_groups);
> +	if (!test_bit(NVME_NSHEAD_DISK_LIVE, &head->flags)) {

This should still be test_and_set_bit() because it is protecting against
two nvme paths simultaneously calling device_add_disk() on the same
namespace head.

> +		rc = device_add_disk(&head->subsys->dev, head->disk,
> +				     nvme_ns_id_attr_groups);
> +		if (rc)
> +			return;
> +		set_bit(NVME_NSHEAD_DISK_LIVE, &head->flags);
>  		nvme_add_ns_head_cdev(head);
>  	}
