Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23004322F8
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Oct 2021 17:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbhJRPh3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 Oct 2021 11:37:29 -0400
Received: from verein.lst.de ([213.95.11.211]:34858 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231893AbhJRPh2 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Oct 2021 11:37:28 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1ADBB68AFE; Mon, 18 Oct 2021 17:35:15 +0200 (CEST)
Date:   Mon, 18 Oct 2021 17:35:14 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, linux-bcache@vger.kernel.org
Subject: Re: [PATCH 1/4] bcache: remove the cache_dev_name field from
 struct cache
Message-ID: <20211018153514.GA32633@lst.de>
References: <20211018060934.1816088-1-hch@lst.de> <20211018060934.1816088-2-hch@lst.de> <dc8601a6-21a5-3680-7489-1430d14788db@suse.de> <20211018152127.GA31195@lst.de> <8c9e20f7-7a58-9ee7-c592-63d5a6162f94@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c9e20f7-7a58-9ee7-c592-63d5a6162f94@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Oct 18, 2021 at 11:32:26PM +0800, Coly Li wrote:
> It was in Linux v4.17 time, when I did the device failure handling. If the 
> underlying device broken and gone, printing the device name string will be 
> a "null" string in kmesg. But the device name was necessary for proper 
> device failure information, we stored the device name string when it was 
> initialized.

I'm pretty sure that was before the %pg specifier and the
hd_struct/block_device unification.  With the current code there is no
way it could print null.
