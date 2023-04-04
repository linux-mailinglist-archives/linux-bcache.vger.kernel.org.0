Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1F76D6ACE
	for <lists+linux-bcache@lfdr.de>; Tue,  4 Apr 2023 19:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbjDDRjX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 4 Apr 2023 13:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236215AbjDDRjK (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 4 Apr 2023 13:39:10 -0400
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7E74687;
        Tue,  4 Apr 2023 10:38:54 -0700 (PDT)
Date:   Tue, 4 Apr 2023 17:38:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
        s=mail; t=1680629925;
        bh=g7Xmkp6P6k5IHx2pSo9vtJJIrKkpePh1vaRO81qxXK8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HjHU2oi9UEjeSvu/5PuuJD1W3DUp4v/PEWC34D+UU6LF55GkHfHL+m5fqlD32c6u9
         4OS3kuA5Nr2BFYJVvv5rlomUE2eMK1ntwo1ksokGwYQFSk9odTONsfNGkPSrGWIQf+
         3zNYoNcawaoRytF5T4QqNyKdyiyT2hITkh5AV3Tw=
From:   Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To:     Coly Li <colyli@suse.de>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcache: make kobj_type structures constant
Message-ID: <4cc38847-a967-487b-8efe-81b741ab6782@t-8ch.de>
References: <20230214-kobj_type-bcache-v1-1-cf00ead7bee7@weissschuh.net>
 <125CA8D6-D3B7-42FB-83BE-DCA688F2ACAF@suse.de>
 <20230214152119.epkfhkojqjvokqmv@t-8ch.de>
 <9DE71214-283C-4410-B5A4-22DFDA7021F4@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9DE71214-283C-4410-B5A4-22DFDA7021F4@suse.de>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,

On 2023-02-15 00:16:03+0800, Coly Li wrote:
> > 2023年2月14日 23:21，Thomas Weißschuh <linux@weissschuh.net> 写道：
> > 
> > On Tue, Feb 14, 2023 at 05:51:09PM +0800, Coly Li wrote:
> >> 
> >> 
> >>> 2023年2月14日 11:13，Thomas Weißschuh <linux@weissschuh.net> 写道：
> >>> 
> >>> Since commit ee6d3dd4ed48 ("driver core: make kobj_type constant.")
> >>> the driver core allows the usage of const struct kobj_type.
> >>> 
> >>> Take advantage of this to constify the structure definitions to prevent
> >>> modification at runtime.
> >>> 
> >> 
> >> How the const structure definition can prevent modification at run time?
> > 
> > It will be put into .rodata instead of .data by the compiler.
> > The .rodata section is mapped as read-only via the pagetable.
> > 
> > See Documentation/security/self-protection.rst
> > "Function pointers and sensitive variables must not be writable".
> 
> I see. Thanks for the information.
> 
> This patch will be added into my testing queue, and submitted later.

It seems this was not submitted.
Or did I miss it?

Thanks,
Thomas
