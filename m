Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE62945F3DE
	for <lists+linux-bcache@lfdr.de>; Fri, 26 Nov 2021 19:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241633AbhKZS0N (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 26 Nov 2021 13:26:13 -0500
Received: from mailbackend.panix.com ([166.84.1.89]:63426 "EHLO
        mailbackend.panix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbhKZSYM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 26 Nov 2021 13:24:12 -0500
Received: from xps-7390 (ip98-184-250-31.oc.oc.cox.net [98.184.250.31])
        by mailbackend.panix.com (Postfix) with ESMTPSA id 4J132w3TH8z3k8m;
        Fri, 26 Nov 2021 13:20:56 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=panix.com; s=panix;
        t=1637950857; bh=phl1aWAH9l464LCaH+K1OWwZCZbZwpyH3ognl/7nR6U=;
        h=Date:From:Reply-To:To:cc:Subject:In-Reply-To:References;
        b=XJJqoaoYmR2L5pVp9YujIXI7lgkDXr8gKqHwPJSUrFsL8d75JBt9u35SRV05z2mDK
         kpOQC35tkxKw8cOKSao2VFFFryM1KaNh7dusAsknfNwa98NfUZLJ7A9FZmxcFyJ9Qh
         dYtApZdDqjfK7bQn7B02GNFLAjz/Cia8LXf6Z+pA=
Date:   Fri, 26 Nov 2021 10:20:55 -0800 (PST)
From:   "Kenneth R. Crudup" <kenny@panix.com>
Reply-To: "Kenneth R. Crudup" <kenny@panix.com>
To:     Jens Axboe <axboe@kernel.dk>
cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nvme@lists.infradead.org,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "Kenneth R. Crudup" <kenny@panix.com>
Subject: Re: Write I/O queue hangup at random on recent Linus' kernels
In-Reply-To: <ddc41b84-c414-006a-0840-250281caf1e5@kernel.dk>
Message-ID: <1ff86d55-f39d-f88b-b8d-b6dfbd2f1b19@panix.com>
References: <b3ba57a7-d363-9c17-c4be-9dbe86875@panix.com> <b9c2681f-e63a-4d3b-913d-d8a75e2c2ea0@kernel.dk> <be6a783-97db-c3bf-b16f-e8c62b14755d@panix.com> <17206ea6-506d-b1de-09e8-c935ff308bd6@kernel.dk> <903be817-4118-f34e-1b35-a0108045590f@kernel.dk>
 <986e942b-d430-783b-5b1c-4525d4a94e48@panix.com> <ddc41b84-c414-006a-0840-250281caf1e5@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


On Fri, 26 Nov 2021, Jens Axboe wrote:

> I'd just do what you usually do, that's usually the best way to gain
> confidence in the fix.
...
> That said, I'm pretty confident in the fix,

OK, then I'll just continue my normal workflow.

... but am I the first report of this you've seen? (I sometimes wonder how many
people use the master branch as a daily driver; an -rc went out a couple of
weeks ago that had a commit that broke suspend that manifested right away.)

	-Kenny

-- 
Kenneth R. Crudup / Sr. SW Engineer, Scott County Consulting, Orange County CA
