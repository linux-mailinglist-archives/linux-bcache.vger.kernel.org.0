Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99CF3E0359
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Aug 2021 16:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238017AbhHDOdu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Aug 2021 10:33:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238703AbhHDOd3 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Aug 2021 10:33:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA66960F58;
        Wed,  4 Aug 2021 14:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628087596;
        bh=C00JtgOcAHMho4HSW46amt4u1PEDLgE0FCLDRj9vJyE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r5GGuOVFvQsum4XAR7C7YBvKDsK/mFn7OHK1uuaLXRstSUvJF6WN5SAcMH42cka84
         XNI6JmV4ddzVk3D3J2YlbCsl6RVftxgl1k5Vs3nz5huKGNFgnQBY2iei65nSAundBj
         gr1MQgM6nEcpjWrclG+PO2XuVtuhgDLnuVCxLN/ur1yVfnHV1jME0OH5CUcgso0JH9
         OkCnqulR6QQPlr+/+sWhnm9w3GZI3LrX0Du7/iC3FQiuwUJ/6hK/4Zm/l13ruiwaM0
         PswWW1T0VxSiyJLTXtgN/AKJ1p4nBl2lAi+w/iFwSNC7dXt6aRCMFqvyz/tryXYCNL
         6UR6ytS23PJoQ==
Date:   Wed, 4 Aug 2021 07:33:12 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Geoff Levand <geoff@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Song Liu <song@kernel.org>, Mike Snitzer <snitzer@redhat.com>,
        Coly Li <colyli@suse.de>, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-um@lists.infradead.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 15/15] nvme: use bvec_virt
Message-ID: <20210804143312.GA2296276@dhcp-10-100-145-180.wdc.com>
References: <20210804095634.460779-1-hch@lst.de>
 <20210804095634.460779-16-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804095634.460779-16-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Aug 04, 2021 at 11:56:34AM +0200, Christoph Hellwig wrote:
> Use bvec_virt instead of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/nvme/host/core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index dfd9dec0c1f6..02ce94b2906b 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -968,12 +968,11 @@ void nvme_cleanup_cmd(struct request *req)
>  {
>  	if (req->rq_flags & RQF_SPECIAL_PAYLOAD) {
>  		struct nvme_ctrl *ctrl = nvme_req(req)->ctrl;
> -		struct page *page = req->special_vec.bv_page;
>  
> -		if (page == ctrl->discard_page)
> +		if (req->special_vec.bv_page == ctrl->discard_page)
>  			clear_bit_unlock(0, &ctrl->discard_page_busy);
>  		else
> -			kfree(page_address(page) + req->special_vec.bv_offset);
> +			kfree(bvec_virt(&req->special_vec));
>  	}
>  }
>  EXPORT_SYMBOL_GPL(nvme_cleanup_cmd);

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>
