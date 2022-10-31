Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B2D612E9A
	for <lists+linux-bcache@lfdr.de>; Mon, 31 Oct 2022 02:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiJaBZX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 30 Oct 2022 21:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiJaBZW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 30 Oct 2022 21:25:22 -0400
X-Greylist: delayed 389 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 30 Oct 2022 18:25:18 PDT
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543AA65ED
        for <linux-bcache@vger.kernel.org>; Sun, 30 Oct 2022 18:25:18 -0700 (PDT)
Date:   Mon, 31 Oct 2022 02:18:40 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=t-8ch.de; s=mail;
        t=1667179124; bh=617eUNqLiB38yb6sJTvFdMViiZTqmNnEwq0zCCUA4oc=;
        h=Date:From:To:Subject:From;
        b=rrDd8TLNskJ3G6vjb63LRwhTnLnSZMSGkPbDhinjJQ3d71zJnT7Jp45I5RFmXUsc3
         m2YPINoKIorS2M99sJBpUylmnm6myFtmpsKjOMqh+xIrVyw5Z5U6k1zQP6DgIhCx9U
         XC3CfnQ9jGVmKBiQ5mY6QlygPo0Kt1nJsaT4n8SE=
From:   Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas@t-8ch.de>
To:     linux-bcache@vger.kernel.org
Subject: bcachefs-tools: O_DIRECT necessary?
Message-ID: <b82ce4e9-7f8f-4f67-a6b9-09dc90ccd49c@t-8ch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Jabber-ID: thomas@t-8ch.de
X-Accept: text/plain, text/html;q=0.2, text/*;q=0.1
X-Accept-Language: en-us, en;q=0.8, de-de;q=0.7, de;q=0.6
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi all,

I just tried to run the unittests of bcachefs-tools and they are failing for
me.
The culprit is that mkfs.bcachefs tries to open the disk image with O_DIRECT
which is not allowed on tmpfs.

Is O_DIRECT really necessary for mkfs? It does not seem necessary for other
filesystems.

Thomas
