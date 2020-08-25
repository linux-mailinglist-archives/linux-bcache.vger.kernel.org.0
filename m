Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF5C251FEA
	for <lists+linux-bcache@lfdr.de>; Tue, 25 Aug 2020 21:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgHYTZF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 25 Aug 2020 15:25:05 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:44940 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbgHYTZE (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 25 Aug 2020 15:25:04 -0400
X-Greylist: delayed 2963 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Aug 2020 15:25:03 EDT
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.15.2/8.15.2) with ESMTP id 07PIZcaC021523;
        Tue, 25 Aug 2020 19:35:38 +0100
From:   Nix <nix@esperi.org.uk>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Subject: Re: [PATCH] bcache-tools: make: permit only one cache device to be specified
References: <20200822163117.25588-1-colyli@suse.de>
Emacs:  ... it's not just a way of life, it's a text editor!
Date:   Tue, 25 Aug 2020 19:35:38 +0100
In-Reply-To: <20200822163117.25588-1-colyli@suse.de> (Coly Li's message of
        "Sun, 23 Aug 2020 00:31:17 +0800")
Message-ID: <877dtmshdx.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC--Metrics: loom 1481; Body=2 Fuz1=2 Fuz2=2
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 22 Aug 2020, Coly Li said:

> Now a cache set only has a single cache, therefore "bache make" should

Typo: "bcache"
