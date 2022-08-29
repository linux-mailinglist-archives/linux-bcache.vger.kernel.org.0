Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0704E5A57A9
	for <lists+linux-bcache@lfdr.de>; Tue, 30 Aug 2022 01:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiH2XeR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 29 Aug 2022 19:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiH2XeQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Aug 2022 19:34:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1596B82851;
        Mon, 29 Aug 2022 16:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=IijE9VZcXhpXniCU02k78oYykjK5r9X2XRaAc/GES+0=; b=z6n3ER6YRXgHRBBOldUxKdStbW
        wnIBVoyKilC7jQUc13QrkMgupTpyDH1ajCQ+zGmn8aQLoFrtgsOytlYempys+vsO0T03nQ0RsPSCo
        NEDOsHiCoFv8Pm1zwtB23gRp50d+sh+5C9/gh545dHNZLz15suiDFK77GJm3c17G1uUDT2+qdOwYw
        sF9mQ8zZQLFWZG3+aFRHvWf/yVEU9JxdH6Yon7imngPh5U29DLkW1xkbIhoTRF+FfbdjqdsFAYeDO
        VAfjgGzA4wlJpS7l/fBkcIDP53H12URSsjisQ5VTDuhZhlmyLl5oEZaYuhxJIAbZ8NJhev5+PHQ5o
        6qQxACug==;
Received: from [2601:1c0:6280:3f0::a6b3]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oSoGl-00DDPl-7L; Mon, 29 Aug 2022 23:34:15 +0000
Message-ID: <1e80af02-ca1a-f320-bd3d-0ab674712da4@infradead.org>
Date:   Mon, 29 Aug 2022 16:34:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH 1/3] lib/time_stats: New library for statistics on events
Content-Language: en-US
To:     Kent Overstreet <kent.overstreet@linux.dev>,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        colyli@suse.de
References: <20220829165344.2958640-1-kent.overstreet@linux.dev>
 <20220829165344.2958640-2-kent.overstreet@linux.dev>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220829165344.2958640-2-kent.overstreet@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



On 8/29/22 09:53, Kent Overstreet wrote:
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index bbe3ef939c..bfb49505c9 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1728,6 +1728,9 @@ config LATENCYTOP
>  	  Enable this option if you want to use the LatencyTOP tool
>  	  to find out which userspace is blocking on what kernel operations.
>  
> +config TIME_STATS
> +	bool
> +

Hi Kent,

Why not just in lib/Kconfig?

thanks.
-- 
~Randy
