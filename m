Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B278D6E2A2C
	for <lists+linux-bcache@lfdr.de>; Fri, 14 Apr 2023 20:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjDNSjA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 14 Apr 2023 14:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjDNSi7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 14 Apr 2023 14:38:59 -0400
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201169743;
        Fri, 14 Apr 2023 11:38:56 -0700 (PDT)
Date:   Fri, 14 Apr 2023 20:38:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
        s=mail; t=1681497535;
        bh=FfkvoRHMnp00ZoRJQzLmg5CF/iTSYQ87lUHUGjhnDrw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Eoy4fNsH65cTX72ZqA9xOblLyAYIN3/8g+zo6TTkwBatjWITXKApV/t4a+IFHUR0z
         epD8Vyri0QYWXk8J1654WK5RvsA2bI+FtjZX2079ErcP2wttAcuOv6CMWyPMtngXzW
         EF9baBA/fNbb7inm3Yatm5gj72OHzyvZWLutXZyY=
From:   Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To:     Coly Li <colyli@suse.de>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcache: make kobj_type structures constant
Message-ID: <3c7289e1-2f21-4adc-bed9-df44fd8988d3@t-8ch.de>
References: <20230214-kobj_type-bcache-v1-1-cf00ead7bee7@weissschuh.net>
 <125CA8D6-D3B7-42FB-83BE-DCA688F2ACAF@suse.de>
 <20230214152119.epkfhkojqjvokqmv@t-8ch.de>
 <9DE71214-283C-4410-B5A4-22DFDA7021F4@suse.de>
 <4cc38847-a967-487b-8efe-81b741ab6782@t-8ch.de>
 <F63C6A45-E428-4557-9995-FDB43CE243B3@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F63C6A45-E428-4557-9995-FDB43CE243B3@suse.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,

On 2023-04-05 21:38:01+0800, Coly Li wrote:
> > 2023年4月5日 01:38，Thomas Weißschuh <linux@weissschuh.net> 写道：
> > 
> > Hi Coly,
> > 
> > On 2023-02-15 00:16:03+0800, Coly Li wrote:
> >>> 2023年2月14日 23:21，Thomas Weißschuh <linux@weissschuh.net> 写道：
> >>> 
> >>> On Tue, Feb 14, 2023 at 05:51:09PM +0800, Coly Li wrote:
> >>>> 
> >>>> 
> >>>>> 2023年2月14日 11:13，Thomas Weißschuh <linux@weissschuh.net> 写道：
> >>>>> 
> >>>>> Since commit ee6d3dd4ed48 ("driver core: make kobj_type constant.")
> >>>>> the driver core allows the usage of const struct kobj_type.
> >>>>> 
> >>>>> Take advantage of this to constify the structure definitions to prevent
> >>>>> modification at runtime.
> >>>>> 
> >>>> 
> >>>> How the const structure definition can prevent modification at run time?
> >>> 
> >>> It will be put into .rodata instead of .data by the compiler.
> >>> The .rodata section is mapped as read-only via the pagetable.
> >>> 
> >>> See Documentation/security/self-protection.rst
> >>> "Function pointers and sensitive variables must not be writable".
> >> 
> >> I see. Thanks for the information.
> >> 
> >> This patch will be added into my testing queue, and submitted later.
> > 
> > It seems this was not submitted.
> > Or did I miss it?
> 
> No I don’t submit it yet. It is not emergent fix, and stay with other testing patches together.
> 
> Do you want it to go now?

No, it's not urgent.

I just assumed it should have been in next by now and thought it got
lost along the way.
Let's keep it with the other testing patches.

Thanks and sorry for bothering you,
Thomas
