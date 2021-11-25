Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E949A45E1FF
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Nov 2021 22:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357198AbhKYVQv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 25 Nov 2021 16:16:51 -0500
Received: from mailbackend.panix.com ([166.84.1.89]:32349 "EHLO
        mailbackend.panix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357070AbhKYVOv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Nov 2021 16:14:51 -0500
Received: from [192.168.126.80] (ip98-184-250-31.oc.oc.cox.net [98.184.250.31])
        by mailbackend.panix.com (Postfix) with ESMTPSA id 4J0VtL06xBz2sbg;
        Thu, 25 Nov 2021 16:11:37 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=panix.com; s=panix;
        t=1637874698; bh=fVNYCI2o8Gl3FzZCspvrDjT0dqKVQsui7DbLR5TdBCE=;
        h=Date:From:Reply-To:To:cc:Subject:In-Reply-To:References;
        b=A7Ls6wj2XBnwsNg2MULnSOPdQxNiIvfc1TqbPbMJBwbHI04fPzby4HhYqHFjrwn/R
         tlAf210tFs5xMn9gdb7U85XN77OiXCbUp81PCx/xJKGLcJKyHQ+yeItR9LODMNn4np
         XmY3POWRNhMqhXfN5jYFiGWqm4aMNeqx6RPVRWcU=
Date:   Thu, 25 Nov 2021 13:11:36 -0800 (PST)
From:   "Kenneth R. Crudup" <kenny@panix.com>
Reply-To: "Kenneth R. Crudup" <kenny@panix.com>
To:     Jens Axboe <axboe@kernel.dk>
cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: Write I/O queue hangup at random on recent Linus' kernels
In-Reply-To: <17206ea6-506d-b1de-09e8-c935ff308bd6@kernel.dk>
Message-ID: <66abbccd-aff0-9b6d-5aa3-f0f17eb4b12f@panix.com>
References: <b3ba57a7-d363-9c17-c4be-9dbe86875@panix.com> <b9c2681f-e63a-4d3b-913d-d8a75e2c2ea0@kernel.dk> <be6a783-97db-c3bf-b16f-e8c62b14755d@panix.com> <17206ea6-506d-b1de-09e8-c935ff308bd6@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


On Thu, 25 Nov 2021, Jens Axboe wrote:

>>> echo 0 > /sys/block/nvme0n1/queue/wbt_lat_usec

>> It's been about 48 hours and haven't seen the issue since doing this.

> Great, thanks for verifying. From your report 5.16-rc2 has the issue, is
> 5.15 fine?

I can check that out sometime in the next few days, but IIRC I pretty sure the
issue hadn't surfaced before the 3rd or 4th of November. I pull from master
at least every 2-3 days, so there's at least a timeframe.

	-Kenny

-- 
Kenneth R. Crudup / Sr. SW Engineer, Scott County Consulting, Orange County CA
