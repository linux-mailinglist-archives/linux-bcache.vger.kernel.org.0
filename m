Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BC045B045
	for <lists+linux-bcache@lfdr.de>; Wed, 24 Nov 2021 00:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237851AbhKWXil (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 23 Nov 2021 18:38:41 -0500
Received: from mailbackend.panix.com ([166.84.1.89]:56886 "EHLO
        mailbackend.panix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240424AbhKWXik (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 23 Nov 2021 18:38:40 -0500
Received: from [192.168.126.80] (ip98-184-250-31.oc.oc.cox.net [98.184.250.31])
        by mailbackend.panix.com (Postfix) with ESMTPSA id 4HzL9F04Y4z2jZm;
        Tue, 23 Nov 2021 18:35:28 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=panix.com; s=panix;
        t=1637710529; bh=HBtWdJ5zUb28ErfUwUNE14xqSlNsDyjDfpzy2cbGpww=;
        h=Date:From:Reply-To:To:cc:Subject:In-Reply-To:References;
        b=exvnzz/eEC966N2LvA2irfRvqxboThIcXUSNxas+VnsNhPDdjDRNrhOOOWfeSwAaJ
         uT7PRfDQUjq4ene50x5eAKvUSRym+aElzpzAfgWIE2yTXvIxZitGSMfp1iI70DSNY3
         1I5rpjHaqIZAFCCXNcKgd91aQczaDRKCRD1cwHUk=
Date:   Tue, 23 Nov 2021 15:35:28 -0800 (PST)
From:   "Kenneth R. Crudup" <kenny@panix.com>
Reply-To: "Kenneth R. Crudup" <kenny@panix.com>
To:     Jens Axboe <axboe@kernel.dk>
cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: Write I/O queue hangup at random on recent Linus' kernels
In-Reply-To: <b9c2681f-e63a-4d3b-913d-d8a75e2c2ea0@kernel.dk>
Message-ID: <acdb51c1-2980-4f79-3fc2-4f834fa7501d@panix.com>
References: <b3ba57a7-d363-9c17-c4be-9dbe86875@panix.com> <b9c2681f-e63a-4d3b-913d-d8a75e2c2ea0@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


On Tue, 23 Nov 2021, Jens Axboe wrote:

> echo 0 > /sys/block/nvme0n1/queue/wbt_lat_usec

Thanks for getting back to me; trying it now. Today seems particularly prone
for some reason (can't figure why, my workflow hasn't changed much) so fingers
crossed.

	-Kenny

-- 
Kenneth R. Crudup / Sr. SW Engineer, Scott County Consulting, Orange County CA
