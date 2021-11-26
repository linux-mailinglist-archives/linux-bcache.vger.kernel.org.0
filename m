Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B59745F34E
	for <lists+linux-bcache@lfdr.de>; Fri, 26 Nov 2021 19:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238241AbhKZSDj (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 26 Nov 2021 13:03:39 -0500
Received: from mailbackend.panix.com ([166.84.1.89]:54991 "EHLO
        mailbackend.panix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239453AbhKZSBj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 26 Nov 2021 13:01:39 -0500
Received: from xps-7390.local (ip98-184-250-31.oc.oc.cox.net [98.184.250.31])
        by mailbackend.panix.com (Postfix) with ESMTPSA id 4J12Xq2bzPz2wQp;
        Fri, 26 Nov 2021 12:58:19 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=panix.com; s=panix;
        t=1637949500; bh=IGNkEdY/1fSW0p0DFCKX6RcLSqM6E0d4vaFMfumBmtw=;
        h=Date:From:Reply-To:To:cc:Subject:In-Reply-To:References;
        b=YS+84g8rKkhBrdTRSchw7CEu/65NpFZwQCMztRP/04D0Apb6Xp0npukJWqyz9R1Z7
         rW5b0GQwPHYDq7mpnV0Gr1f1bVORwnXwhqR2KlLHYOcK+SFQhb/IHOsjgiwH+ttD/g
         q9x4CC/s3UZSA1zOBnR8fHzcnH9rL42Pxjo+3sRs=
Date:   Fri, 26 Nov 2021 09:58:18 -0800 (PST)
From:   "Kenneth R. Crudup" <kenny@panix.com>
Reply-To: "Kenneth R. Crudup" <kenny@panix.com>
To:     Jens Axboe <axboe@kernel.dk>
cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nvme@lists.infradead.org,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "Kenneth R. Crudup" <kenny@panix.com>
Subject: Re: Write I/O queue hangup at random on recent Linus' kernels
In-Reply-To: <903be817-4118-f34e-1b35-a0108045590f@kernel.dk>
Message-ID: <986e942b-d430-783b-5b1c-4525d4a94e48@panix.com>
References: <b3ba57a7-d363-9c17-c4be-9dbe86875@panix.com> <b9c2681f-e63a-4d3b-913d-d8a75e2c2ea0@kernel.dk> <be6a783-97db-c3bf-b16f-e8c62b14755d@panix.com> <17206ea6-506d-b1de-09e8-c935ff308bd6@kernel.dk> <903be817-4118-f34e-1b35-a0108045590f@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


On Fri, 26 Nov 2021, Jens Axboe wrote:

> Can you apply this on top of 5.16-rc2 or current -git and see if it fixes
> it for you?

Since it's related to writeback throttling, is there anything I can try to
taunt it? I was thinking "iozone" or "bonnie++", but if there's something
better, let me know.

	-Kenny

-- 
Kenneth R. Crudup / Sr. SW Engineer, Scott County Consulting, Orange County CA
