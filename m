Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B821FEB1B
	for <lists+linux-bcache@lfdr.de>; Thu, 18 Jun 2020 07:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgFRFtL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 18 Jun 2020 01:49:11 -0400
Received: from smtprelay0003.hostedemail.com ([216.40.44.3]:51102 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725837AbgFRFtK (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 18 Jun 2020 01:49:10 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Jun 2020 01:49:10 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave02.hostedemail.com (Postfix) with ESMTP id 5D35A18009972
        for <linux-bcache@vger.kernel.org>; Thu, 18 Jun 2020 05:42:51 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 1A107181D3025;
        Thu, 18 Jun 2020 05:42:50 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2198:2199:2393:2553:2559:2562:2693:2731:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4304:4321:4605:5007:6691:7576:9149:9545:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12262:12297:12438:12679:12740:12760:12895:13069:13146:13153:13228:13230:13311:13357:13439:14096:14097:14181:14659:14721:21080:21451:21627:21990:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: snow48_1f0962826e0d
X-Filterd-Recvd-Size: 2844
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Thu, 18 Jun 2020 05:42:48 +0000 (UTC)
Message-ID: <48589b2a3ec33a6504d23d166a32e7820d2e0b70.camel@perches.com>
Subject: Re: [PATCH][next] bcache: Use struct_size() in kzalloc()
From:   Joe Perches <joe@perches.com>
To:     Coly Li <colyli@suse.de>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date:   Wed, 17 Jun 2020 22:42:47 -0700
In-Reply-To: <1c6adee3-bbad-dc88-3dd2-af823f279271@suse.de>
References: <20200617222733.GA24156@embeddedor>
         <1c6adee3-bbad-dc88-3dd2-af823f279271@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, 2020-06-18 at 13:38 +0800, Coly Li wrote:
> On 2020/6/18 06:27, Gustavo A. R. Silva wrote:
> > Make use of the struct_size() helper instead of an open-coded version
> > in order to avoid any potential type mistakes.
[]
> > diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
[]
> > -			io = kzalloc(sizeof(struct dirty_io) +
> > -				     sizeof(struct bio_vec) *
> > -				     DIV_ROUND_UP(KEY_SIZE(&w->key),
> > -						  PAGE_SECTORS),
> > +			io = kzalloc(struct_size(io, bio.bi_inline_vecs,
>                                                      ^^^^^^^^^^^^^^^^^^
>                                                      I like this :-)
> 
> > +						DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS)),
> 
> The above line seems too long for 80 characters limitation. Does
> checkpatch.pl complain for this ?

No.  checkpatch has changed:

From bdc48fa11e46f867ea4d75fa59ee87a7f48be144 Mon Sep 17 00:00:00 2001
From: Joe Perches <joe@perches.com>
Date: Fri, 29 May 2020 16:12:21 -0700
Subject: [PATCH] checkpatch/coding-style: deprecate 80-column warning

Yes, staying withing 80 columns is certainly still _preferred_.  But
it's not the hard limit that the checkpatch warnings imply, and other
concerns can most certainly dominate.

Increase the default limit to 100 characters.  Not because 100
characters is some hard limit either, but that's certainly a "what are
you doing" kind of value and less likely to be about the occasional
slightly longer lines.

Miscellanea:

 - to avoid unnecessary whitespace changes in files, checkpatch will no
   longer emit a warning about line length when scanning files unless
   --strict is also used

 - Add a bit to coding-style about alignment to open parenthesis

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 

