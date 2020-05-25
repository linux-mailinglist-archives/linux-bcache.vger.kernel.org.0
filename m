Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6AF1E0E82
	for <lists+linux-bcache@lfdr.de>; Mon, 25 May 2020 14:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390554AbgEYMe1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 25 May 2020 08:34:27 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:50808 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390488AbgEYMe0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 25 May 2020 08:34:26 -0400
Received: from mxbackcorp1j.mail.yandex.net (mxbackcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::162])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id C52572E1499;
        Mon, 25 May 2020 15:34:23 +0300 (MSK)
Received: from iva8-88b7aa9dc799.qloud-c.yandex.net (iva8-88b7aa9dc799.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:88b7:aa9d])
        by mxbackcorp1j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id ZJIXPPS6z9-YLTi9Z9T;
        Mon, 25 May 2020 15:34:23 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1590410063; bh=ai4SFAnq/6nSINx/FBKSEuSs6VEDwe9CKXW2LSyg3rA=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=yMuAin8OkKoPyA6fM61Kd5gq/kMQik8QtpCqmqv1ySlA0gbKNgjehnM/Avo4jesLA
         1NJfntE9wrGKJwo4Sk3LwQYzT/Ut83m1kxlcVbmccuRAiCW947q9+smxOC+ZIq8b+K
         PGM0Lk7vsx2iw92s7aN1ayw2f6hxBIH5GbKWN1pU=
Authentication-Results: mxbackcorp1j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:603::1:c])
        by iva8-88b7aa9dc799.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id O3BMKGQlP9-YLXqqoTf;
        Mon, 25 May 2020 15:34:21 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: block I/O accounting improvements
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
References: <20200525113014.345997-1-hch@lst.de>
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Message-ID: <81f4057b-124a-d0e7-94af-15a198d48d50@yandex-team.ru>
Date:   Mon, 25 May 2020 15:34:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200525113014.345997-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 25/05/2020 14.29, Christoph Hellwig wrote:
> Hi Jens,
> 
> they series contains various improvement for block I/O accounting.  The
> first bunch of patches switch the bio based drivers to better accounting
> helpers compared to the current mess.  The end contains a fix and various
> performanc improvements.  Most of this comes from a series Konstantin
> sent a few weeks ago, rebased on changes that landed in your tree since
> and my change to always use the percpu version of the disk stats.
> 

Thanks for picking this up.

One note about possible further improvement in reply to first patch.

Reviewed-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
