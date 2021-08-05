Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A513E1448
	for <lists+linux-bcache@lfdr.de>; Thu,  5 Aug 2021 14:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241194AbhHEMBa (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 5 Aug 2021 08:01:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230446AbhHEMBa (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 5 Aug 2021 08:01:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A71D61132;
        Thu,  5 Aug 2021 12:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628164876;
        bh=16APo6fE3eY2p/uODzQ81+asSQi2UhYxhFw1Qx5gvPA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GBn0dlwHiVqhZLu0Fo3yWrc2WkaZ8Qxmkal+0DaBkwi+BvGzswN7HO32obdM883P8
         GLXYp5zrCYFSooklqA/+FyCoX3FEdOBcszKoImj7aROLY8frbXu3pVDXLBfWyIDif2
         7JZlUtaEG2Cs6EnBQrEMitiERfXIseQJZZ3Es/tUNvGXwIwE504ASrY3BUGa8BFQKq
         Yn0f6WglLCJr4+2CLWe8GOkmTcQiNYAJ5IZ1S2rgdE92TbRixoDwaSh1iAiFVe10Uo
         tXvaCfm8noqmXKtlQN9Az7jhyrZ6iFBXdlKQsstatDnle26sVhwJ2Qmu8JmMHb8E4/
         AZo5dSnvsRRxg==
Message-ID: <440e1815a8b6f1605b6bce51af6eceadf8e742f7.camel@kernel.org>
Subject: Re: [PATCH 07/15] rbd: use bvec_virt
From:   Jeff Layton <jlayton@kernel.org>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Richard Weinberger <richard@nod.at>,
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
Date:   Thu, 05 Aug 2021 08:01:13 -0400
In-Reply-To: <20210804095634.460779-8-hch@lst.de>
References: <20210804095634.460779-1-hch@lst.de>
         <20210804095634.460779-8-hch@lst.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, 2021-08-04 at 11:56 +0200, Christoph Hellwig wrote:
> Use bvec_virt instead of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/rbd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 6d596c2c2cd6..e65c9d706f6f 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -2986,8 +2986,7 @@ static bool is_zero_bvecs(struct bio_vec *bvecs, u32 bytes)
>  	};
>  
>  	ceph_bvec_iter_advance_step(&it, bytes, ({
> -		if (memchr_inv(page_address(bv.bv_page) + bv.bv_offset, 0,
> -			       bv.bv_len))
> +		if (memchr_inv(bvec_virt(&bv), 0, bv.bv_len))
>  			return false;
>  	}));
>  	return true;

LGTM

Reviewed-by: Jeff Layton <jlayton@kernel.org>

