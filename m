Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A24B2634AB
	for <lists+linux-bcache@lfdr.de>; Wed,  9 Sep 2020 19:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgIIRc0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 9 Sep 2020 13:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgIIRcQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 9 Sep 2020 13:32:16 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182FFC061573;
        Wed,  9 Sep 2020 10:32:16 -0700 (PDT)
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 62F8B844;
        Wed,  9 Sep 2020 17:32:15 +0000 (UTC)
Date:   Wed, 9 Sep 2020 11:32:14 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH] bcache: doc: update
 Documentation/admin-guide/bcache.rst
Message-ID: <20200909113214.6c53912e@lwn.net>
In-Reply-To: <20200821151354.16727-1-colyli@suse.de>
References: <20200821151354.16727-1-colyli@suse.de>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, 21 Aug 2020 23:13:54 +0800
Coly Li <colyli@suse.de> wrote:

> bcache.rst is from the original bcache.txt which was merged in mainline
> kernel v3.10. There are a few things changed in the past 7 years. This
> patch updates bache.rst documents in following content,
> - Update bcache-tools git repo to,
>   https://git.kernel.org/pub/scm/linux/kernel/git/colyli/bcache-tools.git/
> - Update bcache kernel tree to mainline kernel tree,
>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
> - make-bcache util is replaced by the unified bcache util,
>   `make-bcache` now can be performed by `bcache make`
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Kent Overstreet <kent.overstreet@gmail.com>
> ---
>  Documentation/admin-guide/bcache.rst | 31 +++++++++++++++++-----------
>  1 file changed, 19 insertions(+), 12 deletions(-)

I've applied this, thanks.

jon
