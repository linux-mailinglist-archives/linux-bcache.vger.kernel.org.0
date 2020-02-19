Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6FF164A62
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Feb 2020 17:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgBSQaQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 19 Feb 2020 11:30:16 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33394 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgBSQaQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 19 Feb 2020 11:30:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+YTqgPxKXHQcHMkW6GXNHumjMuoizIUcyDnmsogSMbg=; b=A5zup0/mbprngaaymaRX+EGvT8
        XCu7zrWUVVcfv8q01WuUKuot9fF5yMSEoL1H++vNxMgXJZYlNP7Oke/VlP96OtFLUC4sp4wsdc2aO
        uv2lSfFan/Jl4xnBkPxxFFRhcVNWP/p4uwJDmeXS9rhKFTcFaZTetPwoEPngShZo2la6tPb4+fLOp
        ZqWllxBO4h/FINTyA7GHPYThGfLfjAAT5rRC4gdvxmrNFEI82fZDAdwYvN9EQKtdxw0jU/TdX/gvl
        4QaLfV8Kmsimh7DAw0sfUU+AQKwjsOBu2A0V1PbKFQlpw8WAdcXx+q2CD+BVsu7ju4LaQ07Qenim4
        /gFWg9mw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4SEp-0004Xf-JC; Wed, 19 Feb 2020 16:30:15 +0000
Date:   Wed, 19 Feb 2020 08:30:15 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 2/3] bcache: make bch_btree_check() to be multiple threads
Message-ID: <20200219163015.GE10644@infradead.org>
References: <20200215082858.128025-1-colyli@suse.de>
 <20200215082858.128025-3-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200215082858.128025-3-colyli@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

maybe s/be multiple threads/multithreaded/ in the subject?

