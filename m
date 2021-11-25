Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072ED45E1EC
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Nov 2021 22:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237292AbhKYVKb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 25 Nov 2021 16:10:31 -0500
Received: from mailbackend.panix.com ([166.84.1.89]:30564 "EHLO
        mailbackend.panix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbhKYVIb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Nov 2021 16:08:31 -0500
Received: from [192.168.126.80] (ip98-184-250-31.oc.oc.cox.net [98.184.250.31])
        by mailbackend.panix.com (Postfix) with ESMTPSA id 4J0Vl1638fz2sJY;
        Thu, 25 Nov 2021 16:05:17 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=panix.com; s=panix;
        t=1637874318; bh=/phpLN81VHGxqAiAfyH0Geo3FSMKK9AauWc37cUnhQE=;
        h=Date:From:Reply-To:To:cc:Subject:In-Reply-To:References;
        b=eGCNwMmEWIkD/rVJtOna7ZeyO9BUB8nxnWHdUeU1wb8TDU9rJphJ2/XTvCX+Xo76w
         BYhE2efhCHKaIpq7XwKimblUSrkrVGVxnfzyUGPAeJZsbwHXZetcZWVFWYNWILFK7p
         ub0IKxBXH+WxWHmc8eBrEbYQKVHigme0nXEvLnNw=
Date:   Thu, 25 Nov 2021 13:05:16 -0800 (PST)
From:   "Kenneth R. Crudup" <kenny@panix.com>
Reply-To: "Kenneth R. Crudup" <kenny@panix.com>
To:     Jens Axboe <axboe@kernel.dk>
cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nvme@lists.infradead.org,
        "Kenneth R. Crudup" <kenny@panix.com>
Subject: Re: Write I/O queue hangup at random on recent Linus' kernels
In-Reply-To: <b9c2681f-e63a-4d3b-913d-d8a75e2c2ea0@kernel.dk>
Message-ID: <be6a783-97db-c3bf-b16f-e8c62b14755d@panix.com>
References: <b3ba57a7-d363-9c17-c4be-9dbe86875@panix.com> <b9c2681f-e63a-4d3b-913d-d8a75e2c2ea0@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


On Tue, 23 Nov 2021, Jens Axboe wrote:

> It looks like some missed accounting. You can just disable wbt for now, would
> be a useful data point to see if that fixes it. Just do:

> echo 0 > /sys/block/nvme0n1/queue/wbt_lat_usec

> and that will disable writeback throttling on that device.

It's been about 48 hours and haven't seen the issue since doing this.

	-Kenny

-- 
Kenneth R. Crudup / Sr. SW Engineer, Scott County Consulting, Orange County CA
