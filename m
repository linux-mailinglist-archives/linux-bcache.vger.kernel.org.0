Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595376372C9
	for <lists+linux-bcache@lfdr.de>; Thu, 24 Nov 2022 08:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiKXHMk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 24 Nov 2022 02:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiKXHM1 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 24 Nov 2022 02:12:27 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44E0CD95D
        for <linux-bcache@vger.kernel.org>; Wed, 23 Nov 2022 23:13:39 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id k7so716615pll.6
        for <linux-bcache@vger.kernel.org>; Wed, 23 Nov 2022 23:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=l7iB3EBan8MGM2JVW1vGe2BO1Xt8er2t7SvniPXzlos=;
        b=BVcddIj1ZzGlyhxRoubCoLz/6WcH8vjJJ6N9G5AzUTXoZ5UAKtek5clfvoaJLFsE2u
         sU0egTV6baY/6jKxMsUpNamF2rOU5ffr2+vhR0FBuMzu0YGpcfUQPtCJUjYZ10dQBQpQ
         7DMiPb8I9zt8inCvXTctdGEDHvto+Li14MtTOjAk7hl66rGeZxSpsj+/0iJRkDtgY0j2
         1AY6MOWmQAL/vD3ac099WN1v0ARMpjS2uoj/DUG3u9HF2BL6vHujDIWgYKv8gBeqog2K
         o8tlCShc0JNh750WqLgvH3orAj+j18IkmR+P9WWHv6XH+DhwlsxXXDBCB8kwA0pA09B0
         2y5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l7iB3EBan8MGM2JVW1vGe2BO1Xt8er2t7SvniPXzlos=;
        b=OwkUB4yBJfihIaEakckI/x5ER0tltpoAIfG4N8UDG+yKQlog29jROD9UL7wvJAq5eZ
         thYyRQG0QiIG8ZVyc10KcFPU/ex0Z2Nolx2lHpU6mHLxxW37Ly5WljNRxe8ZwHGM/LGT
         1z0nGo7JCJ6NDDrfsyMs1kU31WQ4BC3sHfdbtE+LdLT3iPazZKppIxHgjqq3qBe+bLLt
         BE8Vq+ISFwqirfPM45q1RveHtl8fRFy8Q75KAq8y7S67Kwk+GtH5ERnjcLnOcpD34nYg
         Ah+tF9UmX47vbXzMKVdEzJ5rnZZj5Ago8Gkd9LBfgyRTq3PGaycR8fdkMs1w8sbIQRaE
         lo9w==
X-Gm-Message-State: ANoB5plnZvi14tcULSdYrt6NvSkVEOJZLfX3oZTB1Q5X3hMDGX/9JAxa
        PgJU0qntwYQCkiGP+Xv/1/PkkZ8bWVJcXp1ImaFZRLfMwGM=
X-Google-Smtp-Source: AA0mqf4m8shWok/rHSVm4MLcO/lW7rq1V1XIF4TOAknW6beVJPg5dwHWhejI3KgMnK1QfDK40AbBD/A+BR7QUKoMIWs=
X-Received: by 2002:a17:90b:3d90:b0:212:de1c:a007 with SMTP id
 pq16-20020a17090b3d9000b00212de1ca007mr41575550pjb.30.1669274019176; Wed, 23
 Nov 2022 23:13:39 -0800 (PST)
MIME-Version: 1.0
From:   Clemens Eisserer <linuxhippy@gmail.com>
Date:   Thu, 24 Nov 2022 08:13:14 +0100
Message-ID: <CAFvQSYR0LnRGjKJVWyHdZZz7xmF=rq7Nk3Y+=U3=+FYtfNuMBg@mail.gmail.com>
Subject: automatically detach missing cache devices
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi there,

I am using an usb pen drive as portable rootfs, which works great even
within VirtualBox.
Because it is a bit slow I have configured write-through cache devices
on my main systems and it works great.

However the fact that a bcache device won't initialize in case its
caching device is missing (even for write-through) means I have to
manually detach the cache device of the current computer before
shutdown in case I would like to boot the pendrive somewhere else.
Another option would be to unconditionally remove it during shutdown,
which means I would loose all cached data at every boot - even when
booting the stick a dozen times on the same machine.

Is there some way to tell bcache to detach a caching device
automatically in case it is missing?

Thanks and best regards, Clemens
