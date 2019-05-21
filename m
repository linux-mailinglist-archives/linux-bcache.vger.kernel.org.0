Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFE7124F91
	for <lists+linux-bcache@lfdr.de>; Tue, 21 May 2019 15:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbfEUNCS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 21 May 2019 09:02:18 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:59182 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727812AbfEUNCS (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 21 May 2019 09:02:18 -0400
X-Greylist: delayed 1537 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 May 2019 09:02:16 EDT
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.15.2/8.15.2) with ESMTP id x4L90X8n006123;
        Tue, 21 May 2019 10:00:33 +0100
From:   Nix <nix@esperi.org.uk>
To:     Pierre JUHEN <pierre.juhen@orange.fr>
Cc:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        kent.overstreet@gmail.com
Subject: Re: Critical bug on bcache kernel module in Fedora 30
References: <8ca3ae08-95ce-eb3e-31e1-070b1a078c01@orange.fr>
        <b0a824da-846a-7dc6-0274-3d55f22f9145@suse.de>
        <5cdfb1f7-a4b5-0dff-ae86-e5b74515bda9@suse.de>
        <3204ad50-9340-1ad6-9b72-cf7a70737d09@orange.fr>
Emacs:  more boundary conditions than the Middle East.
Date:   Tue, 21 May 2019 13:36:35 +0100
In-Reply-To: <3204ad50-9340-1ad6-9b72-cf7a70737d09@orange.fr> (Pierre JUHEN's
        message of "Fri, 17 May 2019 06:54:15 +0200")
Message-ID: <87lfz0f0h8.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: loom 1290; Body=4 Fuz1=4 Fuz2=4
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 17 May 2019, Pierre JUHEN verbalised:

> HI again,
>
>> I looked a bit on the code (maybe an old version), however, I saw in the macro defined by btree.c definition of variables of int type.
>
> Could it be a change in GCC, where the default int move from short to long and did have side effects ?

That would be a massive ABI break and would break more or less all
software compiled with GCC 9. So... definitely not, I'd say. :)

-- 
NULL && (void)
