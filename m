Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 148D825AED
	for <lists+linux-bcache@lfdr.de>; Wed, 22 May 2019 01:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfEUXom (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 21 May 2019 19:44:42 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:34270 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfEUXom (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 21 May 2019 19:44:42 -0400
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.15.2/8.15.2) with ESMTP id x4LJi34D013274;
        Tue, 21 May 2019 20:44:03 +0100
From:   Nix <nix@esperi.org.uk>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, kent.overstreet@gmail.com,
        Pierre JUHEN <pierre.juhen@orange.fr>,
        Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Re: Critical bug on bcache kernel module in Fedora 30
References: <8ca3ae08-95ce-eb3e-31e1-070b1a078c01@orange.fr>
        <b0a824da-846a-7dc6-0274-3d55f22f9145@suse.de>
        <5cdfb1f7-a4b5-0dff-ae86-e5b74515bda9@suse.de>
        <cbd597ad-ed21-34ef-1fec-03fa943fd704@orange.fr>
        <cefbcdf6-6ab6-6ab0-8afa-bcd4d85401a5@suse.de>
        <9fc7c451-0507-b5c3-efc8-ab1baf7a1d44@suse.de>
Emacs:  it's not slow --- it's stately.
Date:   Wed, 22 May 2019 00:44:37 +0100
In-Reply-To: <9fc7c451-0507-b5c3-efc8-ab1baf7a1d44@suse.de> (Coly Li's message
        of "Tue, 21 May 2019 21:12:23 +0800")
Message-ID: <878suzfk4a.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC--Metrics: loom 1481; Body=5 Fuz1=5 Fuz2=5
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 21 May 2019, Coly Li uttered the following:
> Also I try to analyze the assemble code of bcache, just find out the
> generated assembly code between gcc9 and gcc7 is quite different. For
> gcc9 there is a XXXX.cold part. So far I can not tell where the problem
> is from yet.

This is hot/cold partitioning. You can turn it off with
-fno-reorder-blocks-and-partition and see if that helps things (and if
it doesn't, it should at least make stuff easier to compare).
