Return-Path: <linux-bcache+bounces-198-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EA8282292B
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Jan 2024 08:57:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 31E3E1F23972
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Jan 2024 07:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B80C18056;
	Wed,  3 Jan 2024 07:57:38 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F78B182C5;
	Wed,  3 Jan 2024 07:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E3A7D68B05; Wed,  3 Jan 2024 08:57:29 +0100 (CET)
Date: Wed, 3 Jan 2024 08:57:29 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Pittman <jpittman@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Coly Li <colyli@suse.de>, Miquel Raynal <miquel.raynal@bootlin.com>,
	Vignesh Raghavendra <vigneshr@ti.com>, linux-um@lists.infradead.org,
	linux-block@vger.kernel.org, nbd@other.debian.org,
	linux-bcache@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 3/9] block: default the discard granularity to sector
 size
Message-ID: <20240103075729.GA485@lst.de>
References: <20231228075545.362768-1-hch@lst.de> <20231228075545.362768-4-hch@lst.de> <CA+RJvhwg3YXAzSk81nMGw=_3OMo6P=XcXBUFUAXSBcyXH6gkDg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+RJvhwg3YXAzSk81nMGw=_3OMo6P=XcXBUFUAXSBcyXH6gkDg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 02, 2024 at 05:11:19PM -0500, John Pittman wrote:
> Hi Christoph, is there a reason you used 512 instead of SECTOR_SIZE
> from include/linux/blk_types.h?  Thanks!

To match the logical_block_size/physical_block_size/io_min
assignments just below.

