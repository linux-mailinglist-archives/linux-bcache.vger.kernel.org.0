Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDB92A37A9
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Nov 2020 01:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbgKCATs (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 2 Nov 2020 19:19:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38785 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgKCATq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Nov 2020 19:19:46 -0500
Received: from 1.is.james.uk.vpn ([10.172.254.24] helo=malefic)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <james.troup@canonical.com>)
        id 1kZk2y-0003dl-1M; Tue, 03 Nov 2020 00:19:36 +0000
Received: from james by malefic with local (Exim 4.94 #2 (Debian))
        id 1kZk2w-000Zd6-Vj; Tue, 03 Nov 2020 00:19:34 +0000
From:   James Troup <james.troup@canonical.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Ilya Dryomov <idryomov@gmail.com>,
        Song Liu <song@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 06/11] md: implement ->set_read_only to hook into BLKROSET processing
References: <20201031085810.450489-1-hch@lst.de>
        <20201031085810.450489-7-hch@lst.de>
Mail-Copies-To: never
Date:   Tue, 03 Nov 2020 00:19:34 +0000
In-Reply-To: <20201031085810.450489-7-hch@lst.de> (Christoph Hellwig's message
        of "Sat, 31 Oct 2020 09:58:05 +0100")
Message-ID: <87y2jjpa09.fsf@canonical.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> @@ -7809,6 +7778,36 @@ static int md_compat_ioctl(struct block_device *bdev, fmode_t mode,

[...]

> +	 * Transitioning to readauto need only happen for arrays that call
> +	 * md_write_start and which are not ready for writes yet.

I realise you're just moving the comment around but perhaps you could
s/readauto/readonly/ while you're doing so?

-- 
James
