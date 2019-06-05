Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2B635648
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Jun 2019 07:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbfFEFng (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 Jun 2019 01:43:36 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49508 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfFEFng (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Jun 2019 01:43:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0nvl81NRj7KH7v4x3HY8gsEUauXzmM0pV++zveLOJ/U=; b=S5O9J46yyvY2NUviueLv2f6RU
        JescWXYUzulwZOWnJmDNZhz0+/PPeUpxkuZHR96V/WBa/8629mdferh3JWBaq9XDw6QJNX6LzN/jd
        J1NKZwqlfb3uFizq6Jew1aA5NREmM/k37ZH45HaXLJFHW9fSXZrclCGDHSiomc1Qj8UVR6jq6+nYn
        gTq5Z38L9ZWHyuqMd7nJMh+KakHhhQuy4L9Glfp+d8q6bIVAxO9S/dwdLI2F035ALKL6e/qukdGsI
        RSKlJ2YMvRhqsYi+XrgHCmQ7tkcrc5nHO0i8TVtXK3QeVBNzpy//8bVe+PMiT6mQo8NqUZbGZyvyZ
        doYzNj64g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYOi0-0002F4-96; Wed, 05 Jun 2019 05:43:36 +0000
Date:   Tue, 4 Jun 2019 22:43:36 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 17/18] bcache: make bset_search_tree() be more
 understandable
Message-ID: <20190605054335.GA7849@infradead.org>
References: <20190604151624.105150-1-colyli@suse.de>
 <20190604155330.107927-1-colyli@suse.de>
 <20190604155330.107927-2-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604155330.107927-2-colyli@suse.de>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

> -			n = j * 2 + (((unsigned int)
> -				      (f->mantissa -
> -				       bfloat_mantissa(search, f))) >> 31);
> +			n = (f->mantissa >= bfloat_mantissa(search, f))
> +				? j * 2
> +				: j * 2 + 1;

If you really want to make it more readable a good old if else would
help a lot.

>  		else
>  			n = (bkey_cmp(tree_to_bkey(t, j), search) > 0)
>  				? j * 2

Same here.
