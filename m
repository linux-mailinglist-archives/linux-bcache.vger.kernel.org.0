Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB5C73A489
	for <lists+linux-bcache@lfdr.de>; Thu, 22 Jun 2023 17:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbjFVPOe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 22 Jun 2023 11:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbjFVPOd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 22 Jun 2023 11:14:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B618C2;
        Thu, 22 Jun 2023 08:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cRVe19OrsPWSomnH8wVHd4nTHq+B5UjIJzhCq40eL2E=; b=j2F+KQnmX6+hrMuGQfZ0+DjThA
        IMfLXYrngdmvP4JvJ5Y2JrP7Vg43RfvZGqjpW12S4yPUldnwChi+8YCAL4QA2UoR/esO9V2Yum8Iq
        P3K8u3Gi/II/5d4YuMPpZtc0jdJMO0GI87Sa4IIbN7dS68xKLw72ZvM10jqitNX2p6uyzNNH3I4zh
        pMKPZzCPftm4CsKCudfwWTPXvH+jcubkmdCxDVfE/ov665wm1PnyRSqI9+hxTq5EIzB9enNUmG9R1
        ATFynZXO+n+wEdI0p8sxw+HF0BbrpxOQOI8XBuP7RBj8jl3enl0t5NyQOL0Q1mVPaY/VbkMl8k++4
        ehMRtEvQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qCM0x-0016DH-0j;
        Thu, 22 Jun 2023 15:14:27 +0000
Date:   Thu, 22 Jun 2023 08:14:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org
Subject: Re: [PATCH 1/2] bcache: Alloc holder object before async registration
Message-ID: <ZJRlU1/7mchdZyPF@infradead.org>
References: <20230621162024.29310-1-jack@suse.cz>
 <20230621162333.30027-1-jack@suse.cz>
 <20230621175659.ugkaawkuanlzt736@moria.home.lan>
 <20230622100954.6vx7725huqngbubb@quack3>
 <20230622120548.molmqze2whj7ykj5@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230622120548.molmqze2whj7ykj5@moria.home.lan>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Jun 22, 2023 at 08:05:48AM -0400, Kent Overstreet wrote:
> Christoph - you really gotta start CCing people properly, the patch that
> broke this didn't even it linux-bcache. No bueno.

The series did absolutely go out to linux-bcache.  See here for v2:

https://lore.kernel.org/linux-bcache/20230608110258.189493-13-hch@lst.de/T/#u
