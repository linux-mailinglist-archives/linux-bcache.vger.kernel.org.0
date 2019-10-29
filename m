Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43ED7E7F32
	for <lists+linux-bcache@lfdr.de>; Tue, 29 Oct 2019 05:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfJ2Ea2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 29 Oct 2019 00:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbfJ2Ea2 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 29 Oct 2019 00:30:28 -0400
Received: from redsun51.ssa.fujisawa.hgst.com (unknown [199.255.47.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3155F20874;
        Tue, 29 Oct 2019 04:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572323428;
        bh=XfZBfCGIoYcdYRhFWcyECCZUCPCrcjjKrAjr5ER0fGg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mgj+a4AQzUayXvhN9/xfpyOnp+Ept9NEiZR/sYAPWhTQalA6Mye1vjARdpHi7rYJT
         D75CukGomJZgumh4b8V1sRVjievEAsCIRc0oZAs3CJPAiBcbGYBW+7CvYOYQAhvG24
         uep/GDK6hO8Byf7cj/u29e6UUr68FcHk845dz3/0=
Date:   Tue, 29 Oct 2019 13:30:24 +0900
From:   Keith Busch <kbusch@kernel.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Subject: Re: [PATCH] block: optimize for small BS IO
Message-ID: <20191029043024.GA9410@redsun51.ssa.fujisawa.hgst.com>
References: <20191029041904.16461-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029041904.16461-1-ming.lei@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Oct 29, 2019 at 12:19:04PM +0800, Ming Lei wrote:
> @@ -309,6 +309,10 @@ void __blk_queue_split(struct request_queue *q, struct bio **bio,
>  				nr_segs);
>  		break;
>  	default:
> +		if (!bio_flagged(*bio, BIO_MULTI_PAGE)) {
> +			*nr_segs = 1;
> +			return;
> +		}
>  		split = blk_bio_segment_split(q, *bio, &q->bio_split, nr_segs);
>  		break;
>  	}

Is there anything to gain by clearing this new flag if the result of
blk_bio_segment_split() creates single page bio's?
