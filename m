Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9005C45F2AC
	for <lists+linux-bcache@lfdr.de>; Fri, 26 Nov 2021 18:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbhKZRPN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 26 Nov 2021 12:15:13 -0500
Received: from mailbackend.panix.com ([166.84.1.89]:39424 "EHLO
        mailbackend.panix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235976AbhKZRNM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 26 Nov 2021 12:13:12 -0500
Received: from [192.168.126.80] (ip98-184-250-31.oc.oc.cox.net [98.184.250.31])
        by mailbackend.panix.com (Postfix) with ESMTPSA id 4J11T20VG8z2s8g;
        Fri, 26 Nov 2021 12:09:57 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=panix.com; s=panix;
        t=1637946598; bh=GTIWo+vkIgU91xH2aEgvdisvV1t6NuTWucivVzjGD88=;
        h=Date:From:Reply-To:To:cc:Subject:In-Reply-To:References;
        b=FR3wRs4snD+sJVhgRXdkjCuO9pDOmRfuJPuD+thdDNttOZ8iYz/py2bPQPPOQtqTx
         6QaR2l5VRmHVqyMjL3+Qc9WpAZt86i3nkzQxKb0bT7YWJtjbjshd7i01543vKu55RY
         yQ0c0RSK4B4YUC/Vm63AlW9UbtFE9ck0stSLTrp0=
Date:   Fri, 26 Nov 2021 09:09:56 -0800 (PST)
From:   "Kenneth R. Crudup" <kenny@panix.com>
Reply-To: "Kenneth R. Crudup" <kenny@panix.com>
To:     Jens Axboe <axboe@kernel.dk>
cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nvme@lists.infradead.org,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "Kenneth R. Crudup" <kenny@panix.com>
Subject: Re: Write I/O queue hangup at random on recent Linus' kernels
In-Reply-To: <903be817-4118-f34e-1b35-a0108045590f@kernel.dk>
Message-ID: <143c4f76-658-887f-5c8-f454785ac99c@panix.com>
References: <b3ba57a7-d363-9c17-c4be-9dbe86875@panix.com> <b9c2681f-e63a-4d3b-913d-d8a75e2c2ea0@kernel.dk> <be6a783-97db-c3bf-b16f-e8c62b14755d@panix.com> <17206ea6-506d-b1de-09e8-c935ff308bd6@kernel.dk> <903be817-4118-f34e-1b35-a0108045590f@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, 26 Nov 2021, Jens Axboe wrote:

> Can you apply this on top of 5.16-rc2 or current -git and see if it fixes
> it for you?

Applied and trying; fingers crossed!

	-Kenny

-- 
Kenneth R. Crudup / Sr. SW Engineer, Scott County Consulting, Orange County CA
