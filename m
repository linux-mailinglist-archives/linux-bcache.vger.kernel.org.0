Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B044488260
	for <lists+linux-bcache@lfdr.de>; Sat,  8 Jan 2022 09:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiAHIbg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 8 Jan 2022 03:31:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59194 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiAHIbg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 8 Jan 2022 03:31:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9639E610D5;
        Sat,  8 Jan 2022 08:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585A6C36AE0;
        Sat,  8 Jan 2022 08:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641630695;
        bh=OKZU2HqdH4HGn5G8tY7pi/i61f+rEqXNsgCKGVe3iME=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q7rgSwP+1clBZ+SIDRdGariYFSjZb/F8pq4kS7EOClOX9cHpiJAgIOGEqtsSQcBhL
         SCdsDsmikeLVfe7WCfrVinbYXEGtYGDZDqMPSN2fgFebfPt+4yDTOm8VMJp2vdk2ak
         +J75+fucuaGXzdAg1hXVMJkbjGbF3udmL134rEKk=
Date:   Sat, 8 Jan 2022 09:31:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Coly Li <colyli@suse.de>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcache: use default_groups in kobj_type
Message-ID: <YdlL4YAScYp9XxkI@kroah.com>
References: <20220106100004.3277439-1-gregkh@linuxfoundation.org>
 <7cbca83d-bcac-464e-d2e4-c54b2d53eead@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cbca83d-bcac-464e-d2e4-c54b2d53eead@suse.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sat, Jan 08, 2022 at 02:16:28PM +0800, Coly Li wrote:
> On 1/6/22 6:00 PM, Greg Kroah-Hartman wrote:
> > There are currently 2 ways to create a set of sysfs files for a
> > kobj_type, through the default_attrs field, and the default_groups
> > field.  Move the bcache sysfs code to use default_groups field which has
> > been the preferred way since aa30f47cf666 ("kobject: Add support for
> > default attribute groups to kobj_type") so that we can soon get rid of
> > the obsolete default_attrs field.
> > 
> > Cc: Coly Li <colyli@suse.de>
> > Cc: Kent Overstreet <kent.overstreet@gmail.com>
> > Cc: linux-bcache@vger.kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> It looks good to me.
> 
> Acked-by: Coly Li <colyli@suse.de>
> 
> I assume you may take this patch directly in your maintenance path, but if
> you want me to take this, just let me know. Thanks.

I can take it myself, or you can, which ever is easiest for you, just
let me know which you prefer.  Thanks for the review!

greg k-h
