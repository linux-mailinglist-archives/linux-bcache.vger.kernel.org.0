Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83469612EA6
	for <lists+linux-bcache@lfdr.de>; Mon, 31 Oct 2022 02:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiJaBlh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 30 Oct 2022 21:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJaBlg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 30 Oct 2022 21:41:36 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2F095A9;
        Sun, 30 Oct 2022 18:41:34 -0700 (PDT)
Date:   Sun, 30 Oct 2022 21:41:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667180492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WO3CL9SUfHkc2ZnW1lnsT6w54LJdlVFocPB1kfgOD+w=;
        b=oPEwLiShnm6vWLTs73MNGlHaG+YcckV0VXoaC2Lspg4mhoa5fJGW7b83weuVSlahoCxuBy
        Gj5uepGr3VN0Ups/SXz4P3kFHNy1w3yKZ/EBN5LO9o/5fn0gVoQqat6g85l7V/U3mJ5iYx
        TXZK4Lr6WZaHiqcuFnCRodH7Prqix5I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas@t-8ch.de>
Cc:     linux-bcache@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs-tools: O_DIRECT necessary?
Message-ID: <20221031014000.hgohrfv7t4dpraia@moria.home.lan>
References: <b82ce4e9-7f8f-4f67-a6b9-09dc90ccd49c@t-8ch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b82ce4e9-7f8f-4f67-a6b9-09dc90ccd49c@t-8ch.de>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Oct 31, 2022 at 02:18:40AM +0100, Thomas Weißschuh wrote:
> Hi all,
> 
> I just tried to run the unittests of bcachefs-tools and they are failing for
> me.
> The culprit is that mkfs.bcachefs tries to open the disk image with O_DIRECT
> which is not allowed on tmpfs.
> 
> Is O_DIRECT really necessary for mkfs? It does not seem necessary for other
> filesystems.

Hey - the proper mailing list for bcachefs is linux-bcachefs@vger.kernel.org now
:)

It's not strictly necessary, we use O_DIRECT because we're emulating the kernel
bio interface. There are other situations where this has been a problem though,
we need to add either a flag to use buffered IO or preferably a way to
automatically fall back to buffered IO.

Could you open a bug for this? I'll try to get to it in the near future

https://github.com/koverstreet/bcachefs/issues/

Cheers,
Kent
