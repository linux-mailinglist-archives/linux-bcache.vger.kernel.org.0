Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64947539A66
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Jun 2022 02:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbiFAAgQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 31 May 2022 20:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbiFAAgO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 31 May 2022 20:36:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C636C87204
        for <linux-bcache@vger.kernel.org>; Tue, 31 May 2022 17:36:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 335AB614A4
        for <linux-bcache@vger.kernel.org>; Wed,  1 Jun 2022 00:36:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FAFC3411D;
        Wed,  1 Jun 2022 00:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654043772;
        bh=5tZfa4f56665L6PROYMmOZFhfws5nB0+lDMx15Gl4hE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mJj1AhLe873iriiKmsGS/eoCnxlYnX/82acEZKUWw1WhrDB/orazW3scq//vjAn9+
         lG+ptdJfMTSMjIZrP6U9Fnqrj82MH1kFBi8yRoju6Hvsorf+TlJerGOm74tqX9HgYT
         /a5BfLTVCc1C49cCveUQgMN8StJ+cy+je1OC/IV9DGYvldH3CFNUCuVd34RKSfZw8w
         3BHotxN9SoRoc8Kxla6kIrclSpijYOBo7FlKgGKi/QJ3Kk8q8Nt11VDRQN6lVyHNFW
         HCtvXwe6VoAjPQHFXyrYhvwY1AIqdyWLhbd+THwSx8LorS0m1Zgp/hZh192ZEWJi/u
         h9H51WYqHyLXg==
Date:   Tue, 31 May 2022 18:36:09 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Christoph Hellwig <hch@infradead.org>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>, Coly Li <colyli@suse.de>
Subject: Re: [RFC] Add sysctl option to drop disk flushes in bcache? (was:
 Bcache in writes direct with fsync)
Message-ID: <Ypa0eVNwr0WjB6Cg@kbusch-mbp.dhcp.thefacebook.com>
References: <Yo1BRxG3nvGkQoyG@kbusch-mbp.dhcp.thefacebook.com>
 <7759781b-dac-7f84-ff42-86f4b1983ca1@ewheeler.net>
 <Yo28kDw8rZgFWpHu@infradead.org>
 <a2ed37b8-2f4a-ef7a-c097-d58c2b965af3@ewheeler.net>
 <YpGsKDQ1aAzXfyWl@infradead.org>
 <24456292.2324073.1653742646974@mail.yahoo.com>
 <YpLmDtMgyNLxJgNQ@kbusch-mbp.dhcp.thefacebook.com>
 <f785ce75-da75-9976-9b60-2dd9f719b96@ewheeler.net>
 <YpZ482qYC929sS+v@kbusch-mbp.dhcp.thefacebook.com>
 <1462334e-d0ae-ded-7d0-57474f6eea@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1462334e-d0ae-ded-7d0-57474f6eea@ewheeler.net>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, May 31, 2022 at 04:04:12PM -0700, Eric Wheeler wrote:
> 
>   * Write-through: write is done synchronously both to the cache and to 
>     the backing store.
> 
>   * Write-back (also called write-behind): initially, writing is done only 
>     to the cache. The write to the backing store is postponed until the 
>     modified content is about to be replaced by another cache block.
>   [ https://en.wikipedia.org/wiki/Cache_(computing)#Writing_policies ]
> 
> 
> So the kernel's notion of "write through" meaning "Drop FLUSH/FUA" sounds 
> like the industry meaning of "write-back" as defined above; conversely, 
> the kernel's notion of "write back" sounds like the industry definition of 
> "write-through"
> 
> Is there a well-meaning rationale for the kernel's concept of "write 
> through" to be different than what end users have been conditioned to 
> understand?

I think we all agree what "write through" vs "write back" mean. I'm just not
sure what's the source of the disconnect with the kernel's behavior.

  A "write through" device persists data before completing a write operation.

  Flush/FUA says to write data to persistence before completing the operation.

You don't need both. Flush/FUA should be a no-op to a "write through" device
because the data is synchronously committed to the backing store automatically.
