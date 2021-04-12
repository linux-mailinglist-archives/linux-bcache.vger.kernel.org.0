Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F8235BFFD
	for <lists+linux-bcache@lfdr.de>; Mon, 12 Apr 2021 11:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238730AbhDLJIf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 12 Apr 2021 05:08:35 -0400
Received: from verein.lst.de ([213.95.11.211]:47859 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238774AbhDLJGV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 12 Apr 2021 05:06:21 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id EC6B668C65; Mon, 12 Apr 2021 11:06:00 +0200 (CEST)
Date:   Mon, 12 Apr 2021 11:06:00 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 7/7] bcache: fix a regression of code compiling failure
 in debug.c
Message-ID: <20210412090600.GA8026@lst.de>
References: <20210411134316.80274-1-colyli@suse.de> <20210411134316.80274-8-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210411134316.80274-8-colyli@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sun, Apr 11, 2021 at 09:43:16PM +0800, Coly Li wrote:
> The patch "bcache: remove PTR_CACHE" introduces a compiling failure in
> debug.c with following error message,
>   In file included from drivers/md/bcache/bcache.h:182:0,
>                    from drivers/md/bcache/debug.c:9:
>   drivers/md/bcache/debug.c: In function 'bch_btree_verify':
>   drivers/md/bcache/debug.c:53:19: error: 'c' undeclared (first use in
>   this function)
>     bio_set_dev(bio, c->cache->bdev);
>                      ^
> This patch fixes the regression by replacing c->cache->bdev by b->c->
> cache->bdev.

Why not fold this into the offending patch?
