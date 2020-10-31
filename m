Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A862A1B7D
	for <lists+linux-bcache@lfdr.de>; Sun,  1 Nov 2020 01:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgKAAfM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 31 Oct 2020 20:35:12 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:64548 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgKAAfM (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 31 Oct 2020 20:35:12 -0400
X-Greylist: delayed 2038 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Oct 2020 20:35:11 EDT
Received: from host86-155-135-88.range86-155.btcentralplus.com ([86.155.135.88] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kZ01k-000CBn-3t; Sat, 31 Oct 2020 23:11:16 +0000
Subject: Re: [PATCH 01/11] mtd_blkdevs: don't override BLKFLSBUF
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Song Liu <song@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
References: <20201031085810.450489-1-hch@lst.de>
 <20201031085810.450489-2-hch@lst.de>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <5170a536-09c1-28a7-c2fb-5381598194db@youngman.org.uk>
Date:   Sat, 31 Oct 2020 23:11:14 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201031085810.450489-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 31/10/2020 08:58, Christoph Hellwig wrote:
> BLKFLSBUF does not actually send a flush command to the device, but
> teard down buffer cache structures.  Remove the mtd_blkdevs
   ^^^^^  ?tears?

> implementation and just use the default semantics instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Cheers,
Wol
