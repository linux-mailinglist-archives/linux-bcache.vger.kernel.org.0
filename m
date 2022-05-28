Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6A9536AD3
	for <lists+linux-bcache@lfdr.de>; Sat, 28 May 2022 06:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236651AbiE1E7d (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 28 May 2022 00:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235749AbiE1E7c (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 28 May 2022 00:59:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D00111E1C9;
        Fri, 27 May 2022 21:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=I6GCrYizEHBFAOs821vvXvYfsFS7YQawP3WHmCMuohI=; b=BLblWJHCAq5D3v2HE8ca/iciVT
        HdhjFa5NeIiShLcGQVu/GBV/AR8xC/+0VSIC6dYKYggm0HFOY92lueMLiqxBwzuno1E/SAOIh4qOX
        MX0cLktsi3P8sESizSixXUvuimTQrxpkt4ltUPqyvGYNQsiQPaSeOStNy6xAy2v0hwyzcrvgo29mH
        thxuTWysjV4FyJPMOj+Jc0/q0CMwJMRwWQAEoa5YVN4ZJuTwuM6bv919nUqMVaJ/OaqGJckO6fO86
        5c5MRTS3A2VSyB3bR+z/OITykGzU13O7fP4JpHQyzRSaFfud0K/cAOe6wBGI4Hp7MSaw6Rl4cyatl
        Yxzq05dA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nuoXo-001SGP-Td; Sat, 28 May 2022 04:59:20 +0000
Date:   Fri, 27 May 2022 21:59:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Keith Busch <kbusch@kernel.org>, Coly Li <colyli@suse.de>,
        Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>,
        linux-block@vger.kernel.org
Subject: Re: [RFC] Add sysctl option to drop disk flushes in bcache? (was:
 Bcache in writes direct with fsync)
Message-ID: <YpGsKDQ1aAzXfyWl@infradead.org>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com>
 <958894243.922478.1652201375900@mail.yahoo.com>
 <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net>
 <27ef674d-67e-5739-d5d8-f4aa2887e9c2@ewheeler.net>
 <YoxuYU4tze9DYqHy@infradead.org>
 <5486e421-b8d0-3063-4cb9-84e69c41b7a3@ewheeler.net>
 <Yo1BRxG3nvGkQoyG@kbusch-mbp.dhcp.thefacebook.com>
 <7759781b-dac-7f84-ff42-86f4b1983ca1@ewheeler.net>
 <Yo28kDw8rZgFWpHu@infradead.org>
 <a2ed37b8-2f4a-ef7a-c097-d58c2b965af3@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2ed37b8-2f4a-ef7a-c097-d58c2b965af3@ewheeler.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, May 27, 2022 at 06:52:22PM -0700, Eric Wheeler wrote:
> Adriano who started this thread (cc'ed) reported that setting 
> queue/write_cache to "write back" provides much higher latency on his NVMe 
> than "write through"; I tested a system here and found the same thing.
>
> [...]
>
> Is this expected?

Once you do that, the block layer ignores all flushes and FUA bits, so
yes it is going to be a lot faster.  But also completely unsafe because
it does not provide any data durability guarantees.
