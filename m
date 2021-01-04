Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1788A2E923A
	for <lists+linux-bcache@lfdr.de>; Mon,  4 Jan 2021 09:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbhADI5o (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 4 Jan 2021 03:57:44 -0500
Received: from verein.lst.de ([213.95.11.211]:56933 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbhADI5o (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Jan 2021 03:57:44 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4F68068AFE; Mon,  4 Jan 2021 09:57:02 +0100 (CET)
Date:   Mon, 4 Jan 2021 09:57:02 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: Re: [PATCH 6/6] bcache: don't pass BIOSET_NEED_BVECS for the
 'bio_set' embedded in 'cache_set'
Message-ID: <20210104085702.GE28949@lst.de>
References: <20201230003255.3450874-1-ming.lei@redhat.com> <20201230003255.3450874-7-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201230003255.3450874-7-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Dec 30, 2020 at 08:32:55AM +0800, Ming Lei wrote:
> This bioset is just for allocating bio only from bio_next_split, and it needn't
> bvecs, so remove the flag.

Overly long line above.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
