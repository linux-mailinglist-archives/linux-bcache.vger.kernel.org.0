Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D30E53B2F2
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Jun 2022 07:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiFBF0i (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Jun 2022 01:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiFBF0h (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Jun 2022 01:26:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8815B22E690;
        Wed,  1 Jun 2022 22:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kqwi6XHwPlv0etYm4RkwSAM0sr2Z6yzbSuDJz6QO5LY=; b=T8i+lMh9Pddi+Qh9BH9jKYIIcX
        zngHpAzl6O+P3ONBkXzaOgwwybnJn4Ri0RN0yrCles6i0D0PaNsCxOhGTQI52ph0qqPzWfZpB/IZo
        qf5Zp9DtPviRSOGjbp6gTvuLX1Zqq6i/DCPR5CgIBtyn7XMtqGsm54SmGx8ZA/7xIt5IlZOgfqmOw
        p83aU6XtIZZwzm8DzjO9IispMM6WonAUTXjxFk1QB/M9vVMQ6ZUnQaW+ZWZ9gxJUGibmUMQVfgYbv
        E6idulsJWzFXnTRCrRuORYaw2bxiBHQTmOZoWjatv/ZivXTBL7A0kmq2nKnM5XeIWXRab5yD70pbr
        4O5Js4rg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nwdLm-001RYo-0A; Thu, 02 Jun 2022 05:26:26 +0000
Date:   Wed, 1 Jun 2022 22:26:25 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Keith Busch <kbusch@kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Coly Li <colyli@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [RFC] Add sysctl option to drop disk flushes in bcache? (was:
 Bcache in writes direct with fsync)
Message-ID: <YphKAWHfhsCKZbBs@infradead.org>
References: <7759781b-dac-7f84-ff42-86f4b1983ca1@ewheeler.net>
 <Yo28kDw8rZgFWpHu@infradead.org>
 <a2ed37b8-2f4a-ef7a-c097-d58c2b965af3@ewheeler.net>
 <YpGsKDQ1aAzXfyWl@infradead.org>
 <24456292.2324073.1653742646974@mail.yahoo.com>
 <YpLmDtMgyNLxJgNQ@kbusch-mbp.dhcp.thefacebook.com>
 <2064546094.2440522.1653825057164@mail.yahoo.com>
 <YpTKfHHWz27Qugi+@kbusch-mbp.dhcp.thefacebook.com>
 <1295433800.3263424.1654111657911@mail.yahoo.com>
 <8a95d4f-b263-5231-537d-b1f88fdd5090@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a95d4f-b263-5231-537d-b1f88fdd5090@ewheeler.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Jun 01, 2022 at 02:11:35PM -0700, Eric Wheeler wrote:
> It looks like the NVMe works well except in 512b situations.  Its 
> interesting that --force-unit-access doesn't increase the latency: Perhaps 
> the NVMe ignores sync flags since it knows it has a non-volatile cache.

NVMe (and other interface) SSDs generally come in two flavors:

 - consumer ones have a volatile write cache and FUA/Flush has a lot of
   overhead
 - enterprise ones with the grossly nisnamed "power loss protection"
   feature have a non-volatile write cache and FUA/Flush has no overhead
   at all

If this is an enterprise drive the behavior is expected.  If on the
other hand it is a cheap consumer driver chances are it just lies, which
there have been a few instances of.
