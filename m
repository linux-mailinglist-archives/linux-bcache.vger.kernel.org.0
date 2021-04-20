Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9673651D8
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Apr 2021 07:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbhDTFhM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 20 Apr 2021 01:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbhDTFhL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 20 Apr 2021 01:37:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070B7C06174A;
        Mon, 19 Apr 2021 22:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=E80vu8vN7GJxG3sssA2Eh6oKzcyJGq2fuBr9GFHQiJQ=; b=G5qsp4Aw0Yy5PO/bBeguWTiGys
        QFKlQ7TVwaBh80CSzYaUkOt3V7NaV9oLbgKBF41wrfIfTy9HOkaJhFUBkcskfsZQbESWF5vaR+rb3
        XJf/KRV0pRoaF/6/oqA4Uwu4VxFakDt+SwD5O9ORi0vQkk055m/O/BjZAXmjHQxEdwb0O3Tv83bQl
        jTqrRsoTGEgF6/YNWYIs5AaIz5/5oi/B+l0I59xesO9Ptba7ve6SmO9JhbaPKThbR/WPOcTE8rbVe
        CeJdjMBPmDby8DMOkifR1s432cMRDtQWk15v+1vcWWFtEPOjrFfAEjg8rRRQaPQFGIEiItsCJGDby
        2sKwOEvQ==;
Received: from [2601:1c0:6280:3f0::df68]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lYj3R-00El9P-QP; Tue, 20 Apr 2021 05:36:17 +0000
Subject: Re: [PATCH 1/2] bcache: Kconfig dependence fix for NVDIMM support
To:     Coly Li <colyli@suse.de>, axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20210420044452.88267-1-colyli@suse.de>
 <20210420044452.88267-2-colyli@suse.de>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <047f5cb5-3084-bc5e-58b3-b3596901066e@infradead.org>
Date:   Mon, 19 Apr 2021 22:36:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210420044452.88267-2-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/19/21 9:44 PM, Coly Li wrote:
> In drivers/md/bcache/Kconfig, setting BCACHE_NVM_PAGES to "selected"
> LIBNVDIMM and DAX is improper. This patch changes to Kconfig dependance
> from "selected" to "depends on" for LIBNVDIMM and DAX.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Coly Li <colyli@suse.de>

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested


Thanks.

> ---
>  drivers/md/bcache/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
> index 0996e366ad0b..59999f24d89e 100644
> --- a/drivers/md/bcache/Kconfig
> +++ b/drivers/md/bcache/Kconfig
> @@ -40,7 +40,7 @@ config BCACHE_NVM_PAGES
>  	bool "NVDIMM support for bcache (EXPERIMENTAL)"
>  	depends on BCACHE
>  	depends on PHYS_ADDR_T_64BIT
> -	select LIBNVDIMM
> -	select DAX
> +	depends on LIBNVDIMM
> +	depends on DAX
>  	help
>  	nvm pages allocator for bcache.
> 


-- 
~Randy

