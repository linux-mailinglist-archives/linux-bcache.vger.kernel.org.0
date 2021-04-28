Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901CE36DCD7
	for <lists+linux-bcache@lfdr.de>; Wed, 28 Apr 2021 18:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239774AbhD1QUU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 28 Apr 2021 12:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239696AbhD1QUT (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 28 Apr 2021 12:20:19 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6125CC061573;
        Wed, 28 Apr 2021 09:19:32 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id t18so6104171wry.1;
        Wed, 28 Apr 2021 09:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=NJWgp0DVo201XCLLpj1xRC5xodv9ORKraGgrH9Sa6nk=;
        b=H5yBNcNnOVTvFGhuXFBT0NJXra62094ceVdHQ3VU+IZwolrFx9guwIv7En2biyu3ZB
         nHPKhV79pJKPAG834582rdlKa5m9H53jZvXHPz/ShNKMpDzz8SrrOHICu6fnRd0IyED9
         ljdhuzavJP46ii3GbT9J9o9Ac7qwS9d06ky+r735cB89dOJ7b87+UoJHrQNPliQC7ZxC
         gG8/nl3GPqrHu6SAdyiLItcPJpI2zz6IMOg9Gb2e6u69WgPwQyNleY89zimVeCE10nrf
         9i7dSZFcrYHtPFuDvhKblTFldVXgZAITRpXurL9TZlpne3oF/1w8Wi0I2T/khCTg16kk
         xyqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=NJWgp0DVo201XCLLpj1xRC5xodv9ORKraGgrH9Sa6nk=;
        b=sX9HMrIyD3Scmnnggr1b3/+W/6EoLNZagWzIimE96vnD07M4J/88pZHflD3PDN2wb7
         D2RdMQ04F3JnHC1cnbfktErObmYce10MXGn4NGnvA/ui8aJq/QBaV+3bHPelNz6Wvaqv
         aoLWbO/z879F8czvD2ZsHNT1w7p8sE5gJzInzH9RzkfuX+Rg4YISK9LCI/IFE8hciAuJ
         h9NJsACxYxPToaZKsGGcYjsXGy/0/ZBdiwIZVG8sXXb6Hl9c9e0cQ0DQgu/TRbnYQSIi
         30IXdAhMl01d5qkBLYNULp5u014Yc1dH2PUtBdxT2zUnkHl02N8oSWsfzTVrt3L51AJd
         BZIQ==
X-Gm-Message-State: AOAM531x5M39c8PC6Xl8wgRXhKX/qpuc2OmhdNl2KAwe93OAFaMxWg/6
        GQ2KKp1rdPknLQtuHlw//wg=
X-Google-Smtp-Source: ABdhPJykbVHss9uwP1THmOmVyxw5sbaWWh0yRvRr84fTwcc64K60W9oCzIFcceXhGvBHjlyLkjdh3g==
X-Received: by 2002:a5d:4a87:: with SMTP id o7mr16543757wrq.102.1619626771226;
        Wed, 28 Apr 2021 09:19:31 -0700 (PDT)
Received: from 192.168.10.5 ([39.46.118.120])
        by smtp.gmail.com with ESMTPSA id i20sm6679250wmq.29.2021.04.28.09.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 09:19:30 -0700 (PDT)
Message-ID: <0b4b7c5cc2f19d2d77a66c0d2ce42f63692174d9.camel@gmail.com>
Subject: Re: [PATCH -next] bcache: use DEFINE_MUTEX() for mutex lock
From:   Muhammad Usama Anjum <musamaanjum@gmail.com>
To:     Coly Li <colyli@suse.de>, Zheng Yongjun <zhengyongjun3@huawei.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     musamaanjum@gmail.com, linux-bcache@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Wed, 28 Apr 2021 21:19:26 +0500
In-Reply-To: <d7f70ce31f6f61a50c05a5d5ba03582054f144fe.camel@gmail.com>
References: <20210405101453.15096-1-zhengyongjun3@huawei.com>
         <42c3e33d-c20e-0fdd-f316-5084e33f9a3b@suse.de>
         <d7f70ce31f6f61a50c05a5d5ba03582054f144fe.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, 2021-04-06 at 02:17 +0500, Muhammad Usama Anjum wrote:
> On Mon, 2021-04-05 at 22:02 +0800, Coly Li wrote:
> > On 4/5/21 6:14 PM, Zheng Yongjun wrote:
> > > mutex lock can be initialized automatically with DEFINE_MUTEX()
> > > rather than explicitly calling mutex_init().
> > > 
> > > Reported-by: Hulk Robot <hulkci@huawei.com>
> > > Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> > 
> > NACK. This is not the first time people try to "fix" this location...
> > 
> > Using DEFINE_MUTEX() does not gain anything for us, it will generate
> > unnecessary extra size for the bcache.ko.
> > ines.
> 
> How can the final binary have larger size by just static declaration?
> By using DEFINE_MUTEX, the mutex is initialized at compile time. It'll
> save initialization at run time and one line of code will be less also
> from text section. 
> 
> #### with no change (dynamic initialization)
> size drivers/md/bcache/bcache.ko
>    text	   data	    bss	    dec	    hex	filename
>  187792	  25310	    152	 213254	  34106	drivers/md/bcache/bcache.ko
> 
> #### with patch applied (static initialization)
>    text	   data	    bss	    dec	    hex	filename
>  187751	  25342	    120	 213213	  340dd	drivers/md/bcache/bcache.ko
> 
> Module's binary size has decreased by 41 bytes with the path applied
> (x86_64 arch).
> 
Anybody has any thoughts on it?


