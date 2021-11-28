Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF69C460280
	for <lists+linux-bcache@lfdr.de>; Sun, 28 Nov 2021 01:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbhK1AQw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 27 Nov 2021 19:16:52 -0500
Received: from mailbackend.panix.com ([166.84.1.89]:18586 "EHLO
        mailbackend.panix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbhK1AOv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 27 Nov 2021 19:14:51 -0500
Received: from xps-7390.lan (mobile-166-172-187-190.mycingular.net [166.172.187.190])
        by mailbackend.panix.com (Postfix) with ESMTPSA id 4J1pn21bDvz3rvq;
        Sat, 27 Nov 2021 19:11:34 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=panix.com; s=panix;
        t=1638058295; bh=54ypOB+ijgfXMIzAJ3Y0gyBZ73m6bLpMirz7eYhg7Zw=;
        h=Date:From:Reply-To:To:cc:Subject:In-Reply-To:References;
        b=RO/d+G0ZjwEhnybrmtseZs4rGg4ih6PNn2ORJl6olZDHHDZeVY4XrkB5PuIQsJRQT
         /CBkkcqNI9d4KcEgltil+OO6NhblXO1crj4UtUN9pr7u8RH/ESo4dJOwEB8HEbyIqX
         xKO8ta54U/AsaAF5DSC7rUQ0V4XextNQxIAZxHqc=
Date:   Sat, 27 Nov 2021 16:11:31 -0800 (PST)
From:   "Kenneth R. Crudup" <kenny@panix.com>
Reply-To: "Kenneth R. Crudup" <kenny@panix.com>
To:     Jens Axboe <axboe@kernel.dk>
cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nvme@lists.infradead.org,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "Kenneth R. Crudup" <kenny@panix.com>
Subject: Re: Write I/O queue hangup at random on recent Linus' kernels
In-Reply-To: <a4d728c2-703d-66be-bffd-3bfde0fddf41@kernel.dk>
Message-ID: <b549b4ce-4156-eaab-a146-1fa52f51b642@panix.com>
References: <b3ba57a7-d363-9c17-c4be-9dbe86875@panix.com> <b9c2681f-e63a-4d3b-913d-d8a75e2c2ea0@kernel.dk> <be6a783-97db-c3bf-b16f-e8c62b14755d@panix.com> <17206ea6-506d-b1de-09e8-c935ff308bd6@kernel.dk> <903be817-4118-f34e-1b35-a0108045590f@kernel.dk>
 <986e942b-d430-783b-5b1c-4525d4a94e48@panix.com> <ddc41b84-c414-006a-0840-250281caf1e5@kernel.dk> <1ff86d55-f39d-f88b-b8d-b6dfbd2f1b19@panix.com> <a4d728c2-703d-66be-bffd-3bfde0fddf41@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


On Fri, 26 Nov 2021, Jens Axboe wrote:

>>> That said, I'm pretty confident in the fix,

Moot point kinda, as I see the fix in Linus' master, but yeah, it's working here.

	-Kenny

-- 
Kenneth R. Crudup / Sr. SW Engineer, Scott County Consulting, Orange County CA
