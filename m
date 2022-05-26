Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB21534C3E
	for <lists+linux-bcache@lfdr.de>; Thu, 26 May 2022 11:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbiEZJGo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 26 May 2022 05:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbiEZJGo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 26 May 2022 05:06:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32090EE1D;
        Thu, 26 May 2022 02:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FFAIKEkbJZeiSFekp3ljhU7NUFXzNR9DXxiGVRu0Nx0=; b=z8amMr/6STOSfuq0B9KWyeNlCd
        JkAftNc9BuT65Jmos4DTDJ9mmbB3/w998MVwq93xrnsoINYD9x0wiktO+w+jg73Qmf9uczs263Dfc
        Xj6cuaQMCy+Bz+jCFDVFcJxqVMWdjjKAHH3UwyIQH0hWS+WLCVTnFxIPi3vZ/e9WOSD2KH9whduNf
        MZFgmpn5kw3q1wrFxQYb0CPC/SBvpMYQ+brCpnasu3cbQCP6Gg2NQSWbQvuYWO5VROKwRnp0FzluP
        5AJ3rBNOJP73mJr7rEpJXVtUzbF5EkCNqlXi+vTSHVh6Z+oO2xIVNIg0hrE5JCPIyJ21VFjRBigKk
        IrOszSYQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nu9Rw-00EBBN-Hx; Thu, 26 May 2022 09:06:32 +0000
Date:   Thu, 26 May 2022 02:06:32 -0700
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
Message-ID: <Yo9DGE2xBQBCqUP+@infradead.org>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com>
 <958894243.922478.1652201375900@mail.yahoo.com>
 <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net>
 <27ef674d-67e-5739-d5d8-f4aa2887e9c2@ewheeler.net>
 <YoxuYU4tze9DYqHy@infradead.org>
 <5486e421-b8d0-3063-4cb9-84e69c41b7a3@ewheeler.net>
 <Yo1BRxG3nvGkQoyG@kbusch-mbp.dhcp.thefacebook.com>
 <7759781b-dac-7f84-ff42-86f4b1983ca1@ewheeler.net>
 <Yo28kDw8rZgFWpHu@infradead.org>
 <77e7dbf9-d5bd-424-1ef7-8a1bb49e9010@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77e7dbf9-d5bd-424-1ef7-8a1bb49e9010@ewheeler.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, May 25, 2022 at 11:44:01AM -0700, Eric Wheeler wrote:
> In your experience, which SAS/SATA RAID controllers are best behaved in 
> terms of policies and reporting things like io_opt and 
> writeback/writethrough to the kernel?

I never had actually good experiences with any of them.  That being
said I also haven't used one for years.  For SAS or SATA attachd to
expanders setups I've mostly used the mpt2/3 family of controllers
which are doing okay.
