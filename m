Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53708BBA8F
	for <lists+linux-bcache@lfdr.de>; Mon, 23 Sep 2019 19:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405933AbfIWRdi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 23 Sep 2019 13:33:38 -0400
Received: from mail-ot1-f52.google.com ([209.85.210.52]:40341 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389167AbfIWRdi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 23 Sep 2019 13:33:38 -0400
Received: by mail-ot1-f52.google.com with SMTP id y39so12853899ota.7
        for <linux-bcache@vger.kernel.org>; Mon, 23 Sep 2019 10:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=kNZO7JSW7UvNqK96ZXjL2nsg9rw8HAw4l8f8NaBt0Ss=;
        b=gs1DSHCj7oNdEkOwakXYEFaX0oCZJM8c7RGw7RG7bpflet3spThy83ZR2h5bjUNzD1
         9csCu7HKPH2f8MNXwKAcnDTHMEx+YMtQYxhMWzMYFDmLefx0hEdPsHYTefvUNMSb9orz
         LWzdAquppBuVyT7Pa7VoadRo4c2EE04iOTFecrj4MTjGfYgE+wy4+oKNO82RAc/Vvg+8
         Mv68pOhazK6LsqyMvFjUbryZnyb3IoAdrJa6kKHoEXx/IwTr/AJP0oy7gBzlxGCxe1wb
         pK/lH5SE/l9+OLF65GAI09JF2ybefA8oA15aRy7hn5AUj+kDc8cOWPAt6th3jLIfIcaO
         IOCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=kNZO7JSW7UvNqK96ZXjL2nsg9rw8HAw4l8f8NaBt0Ss=;
        b=prodhZX0aIGZSoG1Q1aBPIMjbuXx+DYzZI8s/hPZDmZFwYlrWVZ7EBuOzN09eT34dm
         sus2I7vmcI3ET1l9AKQm2v6myA0jHx1eBR0kJfd8o+EOlX9JWHCtHokggaM0s7+3hX9X
         trpOdzoW1LaYeNsmB5JZmMybuGonx0DG0ewCZ+6v6papZBMUUJBxPnnDz3WYiR39FUpB
         D0WSoquXhRDUuBTqzaMQsgG4rCL7LnpncjcogUf9Ea+3QkyHCGWYRNVEhYDulK5aBVfu
         UhH7yL/iZtdAMUdCuYtKSQIksOUArLv/MwKxll6INWurYZVdQiVOkt1FQ4BhO1cLazjL
         skvA==
X-Gm-Message-State: APjAAAV0zbje3LinMv/8bIpAX4TJ1oAAEokOhyPLBrjQmrrmS9c3Jn+Y
        ypQN0QJKpFTUhX2K7JA04YcLyt4XuTHkHt9oLhGiFVkO4GM=
X-Google-Smtp-Source: APXvYqwO2k5EaOFSiepf3cicQm3yWeAAiMpNOs+MLMZ01rD+lszq3Rr0mUZJr6eatJ0XHbnA4QCJdsFX7MGPfac0HsU=
X-Received: by 2002:a9d:7006:: with SMTP id k6mr786350otj.303.1569260015541;
 Mon, 23 Sep 2019 10:33:35 -0700 (PDT)
MIME-Version: 1.0
From:   Marcelo RE <marcelo.re@gmail.com>
Date:   Mon, 23 Sep 2019 14:33:24 -0300
Message-ID: <CAG32U2fdDmaSzgCsuc4JVB4L0w_QujcbiK8YWMNVv+Sj4TdbvQ@mail.gmail.com>
Subject: Issue with kernel 5.x
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi.

 have problems running bcache with the kernel 5.x in KUbuntu. It work
fine with kernel 4.x but fail to start with 5.x. Currently using 5.2.3
(linux-image-unsigned-5.2.3-050203-generic).
When power on the laptop, sometimes it start to busybox and sometime
it boot fine.
If boot to busybox, I just enter reboot until it starts correctly.
I tested:
linux-image-4.15.0-29-generic
linux-image-4.15.0-34-generic
linux-image-5.0.0-20-generic
linux-image-5.0.0-21-generic
linux-image-5.0.0-23-generic
linux-image-5.0.0-25-generic
linux-image-5.0.0-27-generic
linux-image-5.0.0-29-generic
linux-image-unsigned-5.2.3-050203-generic

What can be done?

Thanks
