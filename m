Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5A021C01A
	for <lists+linux-bcache@lfdr.de>; Sat, 11 Jul 2020 00:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgGJWry (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 10 Jul 2020 18:47:54 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37756 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726480AbgGJWrx (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 10 Jul 2020 18:47:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594421272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=o54XITo/6OqPCLmpNBoTEabfaxYXChL2R+xYVOK2D8w=;
        b=ZR9/gUDXjZS3e19ZKrFyggk2lBVxIGs0QF+rtrhoibCfWvUhGi6puwiIOmM3F9tExbzDsZ
        S+Tm6OdCZDBl/ohTmP9KbwfF0BZWRLtE4Orv6MegnVw0eUXEioERtf6plTlrMgdAxQc90E
        dO+W/WiVZ8ZxJIQu+0/l/d+1hda2VPM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-s8E7U7W6Osy0wMzIXuZDGw-1; Fri, 10 Jul 2020 18:47:50 -0400
X-MC-Unique: s8E7U7W6Osy0wMzIXuZDGw-1
Received: by mail-qk1-f197.google.com with SMTP id u186so5499754qka.4
        for <linux-bcache@vger.kernel.org>; Fri, 10 Jul 2020 15:47:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version;
        bh=o54XITo/6OqPCLmpNBoTEabfaxYXChL2R+xYVOK2D8w=;
        b=U0QIad9+auvwvOVzW9FLd9V66vAlFSEu3cKdu/oKQfmBtw8c0klSUIeI7BgStJ/TKc
         eqODerJuMbWxMshR6NqfkMpG/tws1nftaF1kH677Fqn+eG48v1aqVbPUov//JJzn1ZUD
         DbM63xXwYcNAJFOGuXlyLnA8uaMJtWg5F/wZvMqv+fndWWrakFXwzffqasp4WnD9FJd0
         +pTFG3iZDmcwfItyQkzOlmV/btTPQzl0NpGM0+ItjHTtAgQJ0N6eCpOt9UCNZy+H+PMT
         a9MQceuofHCSJgHv41plaJ5v2oiykstyPMNnkdauUHOViXmsICmbM8Y4oSIHO3t02Jxs
         zGeQ==
X-Gm-Message-State: AOAM532RaPedO5cQ+nSYyX3jNisOassI6JcmpPw5i0hqVISH7Oh0GJmY
        4GokeFKS2NFjFbKgGn9QUqBM5c5U3UYMFFq+1o3AP3pJm1iJhROW5rn/seZBc4kh/No2ufzCaEX
        89AGE989O8UJnHPM3cqnYvP3J
X-Received: by 2002:a37:7242:: with SMTP id n63mr55395523qkc.143.1594421269974;
        Fri, 10 Jul 2020 15:47:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5aVdupJZ/N436IkABUiRFu1O6g8zBj54WTZtl8wVPJ9mBdxofbPYYNWVhZw6WGZJIdp34rg==
X-Received: by 2002:a37:7242:: with SMTP id n63mr55395512qkc.143.1594421269720;
        Fri, 10 Jul 2020 15:47:49 -0700 (PDT)
Received: from crash (c-73-253-167-23.hsd1.ma.comcast.net. [73.253.167.23])
        by smtp.gmail.com with ESMTPSA id a28sm8618845qko.45.2020.07.10.15.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 15:47:49 -0700 (PDT)
From:   Ken Raeburn <raeburn@redhat.com>
To:     linux-bcache@vger.kernel.org
Subject: bcache integer overflow for large devices w/small io_opt
Date:   Fri, 10 Jul 2020 18:47:48 -0400
Message-ID: <878sfrdm23.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


The long version is written up at
https://bugzilla.redhat.com/show_bug.cgi?id=1783075 but the short
version:

There are devices out there which set q->limits.io_opt to small values
like 4096 bytes, causing bcache to use that for the stripe size, but the
device size could still be large enough that the computed stripe count
is 2**32 or more. That value gets stuffed into a 32-bit (unsigned int)
field, throwing away the high bits, and then that truncated value is
range-checked and used. This can result in memory corruption or faults
in some cases.

The problem was brought up with us on Red Hat's VDO driver team by a
bcache user on a 4.17.8 kernel, has been demonstrated in the Fedora
5.3.15-300.fc31 kernel, and by inspection appears to be present in
Linus's tree as of this morning.

The easy fix would be to keep the quotient in a 64-bit variable until
it's validated, but that would simply limit the size of such devices as
bcache backing storage (in this case, limiting VDO volumes to under 8
TB). Is there a way to still be able to use larger devices? Perhaps
scale up the stripe size from io_opt to the point where the stripe count
falls in the allowed range?

Ken Raeburn
(Red Hat VDO driver developer)

