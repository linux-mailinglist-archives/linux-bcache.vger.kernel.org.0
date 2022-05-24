Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96400532373
	for <lists+linux-bcache@lfdr.de>; Tue, 24 May 2022 08:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbiEXGoH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 24 May 2022 02:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234050AbiEXGoF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 24 May 2022 02:44:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFE37CB40
        for <linux-bcache@vger.kernel.org>; Mon, 23 May 2022 23:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hiYG0doWoNHSl19CzciToKxwixUfyPZAVTaj/Lgu68w=; b=rsU7ZVUg8qbj27IiW8uZPAQD1C
        J6cTqlibwvzq1yT6VsVFm+agQNBcKPmim3f37jMRWmybH3JVyznm8hmMXIjyFlFnfTRC2RaqqvIxh
        orrwkttQ52nUXNOwP8wDCOYVHW5IqMle6fTglaneX1JK3qCrJzS7lqTmGDtdQUypnjNeB7TXSv1rY
        nE3d9GWc/xlaTTtIi/CWeJbwqLORt741MMK8OglnevQ8v6nd7bNiYWLF9u5xYqMHX+ABk1bpvKayN
        dRcFZuMjzCPhkZkOrzIcskC0ERQYapn5hJsssg33NJs8tsWdI9emj+YD3zrYcnbWqhjySU/F9i0uq
        CESFvCGQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ntNBZ-006s2O-GI; Tue, 24 May 2022 05:34:25 +0000
Date:   Mon, 23 May 2022 22:34:25 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Coly Li <colyli@suse.de>,
        Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>,
        linux-block@vger.kernel.org
Subject: Re: [RFC] Add sysctl option to drop disk flushes in bcache? (was:
 Bcache in writes direct with fsync)
Message-ID: <YoxuYU4tze9DYqHy@infradead.org>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com>
 <958894243.922478.1652201375900@mail.yahoo.com>
 <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net>
 <27ef674d-67e-5739-d5d8-f4aa2887e9c2@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27ef674d-67e-5739-d5d8-f4aa2887e9c2@ewheeler.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

... wait.

Can someone explain what this is all about?  Devices with power fail
protection will advertise that (using VWC flag in NVMe for example) and
we will never send flushes.  So anything that explicitly disables
flushed will generally cause data corruption.

