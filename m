Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44623448039
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Nov 2021 14:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239915AbhKHN0R (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Nov 2021 08:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239917AbhKHN0Q (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Nov 2021 08:26:16 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561AAC061570
        for <linux-bcache@vger.kernel.org>; Mon,  8 Nov 2021 05:23:32 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id x10so4745166ioj.9
        for <linux-bcache@vger.kernel.org>; Mon, 08 Nov 2021 05:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=zx65JLNOcPnDI4dtvkfbte1frN4DHKsfW28wO+xNDk8=;
        b=N3p7mfBsF/b9XqjFOHzoQvKO+snYbEhyySBtvG0xgYU1ZjzuKhBlmLTNLyy6bqL741
         EY/2FkRQ4ytvnA8pTw2ae46JWzb5yJVZgaKn2rk5osCACt9kmM1rFMFnfZN1wAFFcj8c
         Hw2Uj9jBBYHOUmuRxKQSkx9cT6xRPkdHkNLgmN73XEJUPQYTHjQmJXHuvt9OcxbnvRCx
         3JfH/EBj9jHUPMiT+pf6IFxAab4ZXt5kphAa4yZYMXBnuWkgkqlIT1zwoTeV2jYjfK7t
         bU21n16ZnV7IpSzPXnxqxKI/rq4NvBjERACJi0H1nxHfA2RsBs7RDoDGtopw3nECtuCj
         pDyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=zx65JLNOcPnDI4dtvkfbte1frN4DHKsfW28wO+xNDk8=;
        b=z0OhA1WRyGS5i+Xog+KdxVIfcDJdaaJOml1BngZ3Q9eiwFSdAY4xaStL5vkKbZQiOJ
         uRP7Op6kggryJDomOFdjj/cqZr/qLBeUx6qJEmJilKQ5xG4UCUTMRKE6RpCy36quhhtc
         ZzI/EGceasYcpq5NUAkyQn64298SyIesgmrxhHv83XsHLfQB9zDmSa6okYVQJgyjfZtO
         Wc7OXQ7W/NlBewFreHMw1z6Bhm/+/1HD8OFKIVX7zmU1xNb9dEXTlN+9V0EkPudbTPbd
         KuTzRnNkWRfL2riyJYDUi+kx3zIK6xXxS/+CrWDsPKhnkdE5MNB1TcUojIIZjPbsDUOR
         KjXw==
X-Gm-Message-State: AOAM533a2uz8sjXd4VkItlaDpuPgI2JNX8ikp/MNfvdeK33jy8rkHkWw
        6pquBKpei4aFIACgpBTLCyh6AQ==
X-Google-Smtp-Source: ABdhPJw5WAMhm8dqmbV0nJCeP1M4lOIsqvKRPj/3pqL9uPEGRkLn5aG9pzKCY3t0f1xHb1Orja2+EA==
X-Received: by 2002:a5e:d602:: with SMTP id w2mr4824918iom.121.1636377811696;
        Mon, 08 Nov 2021 05:23:31 -0800 (PST)
Received: from [127.0.1.1] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id c7sm1192920iob.28.2021.11.08.05.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 05:23:31 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Coly Li <colyli@suse.de>
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org
In-Reply-To: <20211103151041.70516-1-colyli@suse.de>
References: <20211103151041.70516-1-colyli@suse.de>
Subject: Re: [PATCH] bcache: Revert "bcache: use bvec_virt"
Message-Id: <163637780949.313555.17062223275836707712.b4-ty@kernel.dk>
Date:   Mon, 08 Nov 2021 06:23:29 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, 3 Nov 2021 23:10:41 +0800, Coly Li wrote:
> This reverts commit 2fd3e5efe791946be0957c8e1eed9560b541fe46.
> 
> The above commit replaces page_address(bv->bv_page) by bvec_virt(bv) to
> avoid directly access to bv->bv_page, but in situation bv->bv_offset is
> not zero and page_address(bv->bv_page) is not equal to bvec_virt(bv). In
> such case a memory corruption may happen because memory in next page is
> tainted by following line in do_btree_node_write(),
> 	memcpy(bvec_virt(bv), addr, PAGE_SIZE);
> 
> [...]

Applied, thanks!

[1/1] bcache: Revert "bcache: use bvec_virt"
      commit: 2878feaed543c35f9dbbe6d8ce36fb67ac803eef

Best regards,
-- 
Jens Axboe


