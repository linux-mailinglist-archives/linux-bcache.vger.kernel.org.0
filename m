Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C1F533281
	for <lists+linux-bcache@lfdr.de>; Tue, 24 May 2022 22:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbiEXUeX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 24 May 2022 16:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiEXUeW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 24 May 2022 16:34:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CF15DBFE;
        Tue, 24 May 2022 13:34:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6334DB81B9B;
        Tue, 24 May 2022 20:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FC3C34118;
        Tue, 24 May 2022 20:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653424459;
        bh=l8PWfPDmX3Yn/Av/zwsvC05dc68IhTDoBNgUimBabHU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ivHtfYpmWRILl2qCl1OPZZ0PCznT2zQo6vbHAyfQ4STbLlatCM6UUqNNS+niSuqb1
         P/TlFYv/BN1mehB/NhxpiADsFBuLw00n7WLgUAF0JU7KXzcF2izu1DeEuHCxOAduQA
         2fafjLtZeIftyFRUqW4ALBgTQGgILXkkX9131XSkpvn4DhQYEGv8KGLopSTdOHdPso
         II72OCahWpVfcFQ3F7mp7sJHEkDvLGNEKEN/AAgj/Y6z5I+ScjvEvUxaqltpaZHosV
         0CWYcZl4UXCqzGImOUqQMeWKAUxgIf/KGo1gwktEnxh0HAKlqnW50yL0b5IgIHkyWb
         MicNrYyrhTBOw==
Date:   Tue, 24 May 2022 14:34:15 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Christoph Hellwig <hch@infradead.org>, Coly Li <colyli@suse.de>,
        Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>,
        linux-block@vger.kernel.org
Subject: Re: [RFC] Add sysctl option to drop disk flushes in bcache? (was:
 Bcache in writes direct with fsync)
Message-ID: <Yo1BRxG3nvGkQoyG@kbusch-mbp.dhcp.thefacebook.com>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com>
 <958894243.922478.1652201375900@mail.yahoo.com>
 <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net>
 <27ef674d-67e-5739-d5d8-f4aa2887e9c2@ewheeler.net>
 <YoxuYU4tze9DYqHy@infradead.org>
 <5486e421-b8d0-3063-4cb9-84e69c41b7a3@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5486e421-b8d0-3063-4cb9-84e69c41b7a3@ewheeler.net>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, May 24, 2022 at 01:14:18PM -0700, Eric Wheeler wrote:
> Hi Christoph,
> 
> On Mon, 23 May 2022, Christoph Hellwig wrote:
> > ... wait.
> > 
> > Can someone explain what this is all about?  Devices with power fail 
> > protection will advertise that (using VWC flag in NVMe for example) and 
> > we will never send flushes. So anything that explicitly disables flushed 
> > will generally cause data corruption.
> 
> Adriano was getting 1.5ms sync-write ioping's to an NVMe through bcache 
> (instead of the expected ~70us), so perhaps the NVMe flushes were killing 
> performance if every write was also forcing an erase cycle.
> 
> The suggestion was to disable flushes in bcache as a troubleshooting step 
> to see if that solved the problem, but with the warning that it could be 
> unsafe.
> 
> Questions:
> 
> 1. If a user knows their disks have a non-volatile cache then is it safe 
>    to drop flushes?
> 
> 2. If not, then under what circumstances is it unsafe with a non-volatile 
>    cache?
>   
> 3. Since the block layer wont send flushes when the hardware reports that 
>    the cache is non-volatile, then how do you query the device to make 
>    sure it is reporting correctly?  For NVMe you can get VWC as:
> 	nvme id-ctrl -H /dev/nvme0 |grep -A1 vwc
>    
>    ...but how do you query a block device (like a RAID LUN) to make sure 
>    it is reporting a non-volatile cache correctly?

You can check the queue attribute, /sys/block/<disk>/queue/write_cache. If the
value is "write through", then the device is reporting it doesn't have a
volatile cache. If it is "write back", then it has a volatile cache.
